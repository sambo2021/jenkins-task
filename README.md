# For creating local master-jenkins on your local host 
- use master docker file to build image of jenkins master to run a container later from this image 
- this image shall have docker cli to use it to run some docker commands on slave 
- using mounting volumes to connect your local docker daemon to docker cli inside that container of master jenkins  
jenkins-master docker file which i called it master-Dockerfile : 
   
     ```sh
     FROM jenkins/jenkins:lts
     USER root
     RUN apt-get update && apt-get install -y lsb-release
     RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc https://download.docker.com/linux/debian/gpg
     RUN echo "deb [arch=$(dpkg --print-architecture) \
     signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
     https://download.docker.com/linux/debian \
     $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
     RUN apt-get update && apt-get install -y docker-ce-cli
     RUN groupadd docker
     RUN usermod -aG docker jenkins
     USER jenkins
     ```
   ```sh
  docker build -t jenkins-master -f master-Dockerfile .
  docker tag jenkins-master  mohamedsambo/jenkins-master:v1.0 
  docker push mohamedsambo/jenkins-master:v1.0
  docker run -d -it -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock jenkins-master
  docker exec -it jenkins-master cat /var/jenkins_home/secrets/initialAdminPassword
  ```
-  hit your browser at  hhtp://localhost:8080/
- then you can configure your username and password 
- by default jenkins saves all its configurations and installed plugins at /var/jenkins_home 
- ### needed plugins to install on master jenkins 
    #### - Pipeline AWS steps to apply terraform on aws 
    #### - cloudBees AWS credentials to save the credentials in jenkins
    #### - terraform tool
- ### secrets and credentials needed on master jenkins 
    #### - docker hub username and password
    #### - github username and password 
- creating ci pipeline on jenkins master to build infrastructure, ssh on private instance and configure ansible on. 

# For ansible file that gonna run on private instance that would later created as a jenkins slave 
- making a jenkins_home directory 
- installing java jdk 
- installing docker cli and daemon to deploy our application as container 
- copying the previously downloaded jar file to bin dir -> it is needed for making this ec2 as jenkins slave later 
- finally install git , we gonna need it in another pipline cuase it will be executed from the slave ec2 instance to deploy the application on it 
   briefly * the slave would act as a master that connect with git repo and deploy the application on its docker run time environement *

```sh
- hosts: private
  remote_user: ubuntu
  become: yes
  gather_facts: no
  tasks: 
    - name: update apt 
      apt:
        update_cache: yes
    
    - name: creating directory 
      file:
        name: jenkins_home
        state: directory
        mode: 0777

    - name: installing java 
      apt:
        name: openjdk-8-jdk 
        state: present

    - name: Install required system packages
      apt:
        pkg:
          - apt-transport-https
          - ca-certificates
          - curl
          - software-properties-common
          - python3-pip
          - virtualenv
          - python3-setuptools
        state: latest
        update_cache: true

    - name: Add Docker GPG apt Key
      apt_key:
        url: https://download.docker.com/linux/ubuntu/gpg
        state: present

    - name: Add Docker Repository
      apt_repository:
        repo: deb https://download.docker.com/linux/ubuntu focal stable
        state: present

    - name: Update apt and install docker-ce
      apt:
        name: docker-ce
        state: latest
        update_cache: true

    - name: Install Docker Module for Python
      pip:
        name: docker

    # sudo groupadd docker
    - name: Create "docker" group
      group:
        name: "docker"
        state: present

    # sudo usermod -aG docker root
    - name: Add remote "ubuntu" user to "docker" group
      user:
        name: "ubuntu"
        groups: "docker"
        append: yes
    
    - name: Creating bin directory 
      file: 
        path: /home/ubuntu/bin
        state: directory
        mode: 0777
    
    - name: copying the agent jar to the slave 
      copy:
        src:  agent.jar
        dest: /home/ubuntu/bin/agent.jar
  
    - name: install git 
      apt:
        name: git
        state: latest
   ```


# Terraform code to build our infrastructure on aws  
- create 2 subnets , public and private one 
- public subnet would have the bastion host 
- private would have the private instance , rds and elastic casch which are required to run our app 
- private security group would have ports 22,80,443,3000,3306 and 6379 ingress for various purposes such as ssh,http, rds and elastic cash ports handlig comin request of application pod
- external load balancer existes on public subnet and targeting private instance on port 80 *so that we opened port 80 on private subnet * and listen to incomin traffic on LP dns as http from port 80 that opened on public security group 
- using local exec provisioning to downlaod TF_key.pem on my jenkins master and configure it in ~/.ssh dir to use it later 
  in ssh two instances public and private 
- ## need some outputs such as 
      -   loadbalancer_dns_name   -> that url for the application what we gonna use
      -   Application_Instance_IP -> gonna use it in jenkins master ~/.ssh/config file and ssh command 
      -   Bastion_Instance_IP     -> gonna use it in jenkins master ~/.ssh/config file and ssh command
      -   RDS_HOSTNAME            -> used as env variable in application 
      -   RDS_PORT                -> used as env variable in application
      -   REDIS_HOSTNAME          -> used as env variable in application
      -   REDIS_PORT              -> used as env variable in application

# SSH Proxy Command : Going through one host to reach another server 
- you may notice that at the last two steps in jenkins file 
- now we need to add the private instance under the name private to use it later as hoast name such like /etc/hosts 1270.0.0.1
  localhost , the purpose of that to use them in ssh and applying ansible code with the name of private and bastion instead of using ips , also configuring the port number that jenkins master will ssh private instance on and its ip which is terraform output Application_Instance_IP comes out of output.tf and adentify the private key that jenkins master would ssh by which is ~/.ssh/TF_key.pem
- StrictHostKeyChecking no -> when StrictHostKeyChecking is enabled the ssh client connects only to known hosts with valid ssh host keys that are stored in the known hosts list, briefly this still means hostkeys are still added to .ssh/known_hosts but you wont be prompted about whether you trust them and to avoid the warning that comes after changing hosts if that happen for any reason we gonna add UserKnownHostsFile /dev/null
- UserKnownHostsFile /dev/null -> this adds newly discovered hosts to the trash bin to add advantage of if a host key changes
  then there is no problem 
  ```sh
  stage('Configure SSH'){
          steps{
             withAWS(credentials: 'jenkins-user', region: 'us-west-2') {
                // sh 'terraform apply  --var-file=prod.tfvars --auto-approve'
                
                 sh """
                chmod 400 ~/.ssh/TF_key.pem
                echo "
               Host private
                     Port 22
                     HostName `terraform output Application_Instance_IP`
                     User ubuntu
                     IdentityFile ~/.ssh/TF_key.pem
                     StrictHostKeyChecking no
                     UserKnownHostsFile /dev/null
                     ServerAliveInterval 60
                     ServerAliveCountMax 30
                  Host bastion
                     HostName  `terraform output Bastion_Instance_IP`
                     User ubuntu
                     StrictHostKeyChecking no
                     UserKnownHostsFile /dev/null
                     IdentityFile ~/.ssh/TF_key.pem
                  " >  ~/.ssh/config
                """
                }
               
             }
          }
  ```

  - now at adding that private instance as jemkins slave node i shall provide its name private and lable private-slave and ssh during proxy command -> ssh -o ProxyCommand="ssh -W %h:%p -q bastion" -i ~/.ssh/TF_key.pem ubuntu@private exec java -jar ~/bin/agent.jar

  - label private slave cause i use at jenkins file label (! private-slave ) to run that pipeline through the byuit-in node "master slave"
  - in proxy command that ~/.ssh/TF_key.pem on jenkins master 
  - in proxy command that ubuntu@private  the user of private instance is ubuntu and i already resolved its private ip to the hostname private in ~/.ssh/config file on master jenkins 


