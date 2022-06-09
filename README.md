# for creating local master-jenkins on your local host 
1- use master docker file to build image of jenkins master to run a container later from this image 
2- this image shall have docker cli to use it to run some docker commands on slave 
3- using mounting volumes to connect your local docker daemon to docker cli inside that container of master jenkins  
jenkins-master docker file which i called it master-Dockerfile : 
    ----------------------------------
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
    ----------------------------------
4-  #docker build -t jenkins-master -f master-Dockerfile .
5-  #docker tag jenkins-master  mohamedsambo/jenkins-master:v1.0 
6-  #docker push mohamedsambo/jenkins-master:v1.0
7-  #docker run -d -it -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock jenkins-master
8-  #docker exec -it jenkins-master cat /var/jenkins_home/secrets/initialAdminPassword
9-  hit your browser at  hhtp://localhost:8080/
10- then you can configure your username and password 
11- by default jenkins saves all its configurations and installed plugins at /var/jenkins_home 
12- needed plugins to install on master jenkins 
    - Pipeline AWS steps to apply terraform on aws 
    - cloudBees AWS credentials to save the credentials in jenkins
    - terraform tool
13- secrets and credentials needed on master jenkins 
    - docker hub username and password
    - github username and password 
14- creating ci pipeline on jenkins master to build infrastructure, ssh on private instance and configure ansible on. 

# for ansible file that donna run on private instance that would later created as a jenkins slave 
1- making a jenkins_home directory 
2- installing java jdk 
3- installing docker cli and daemon to deploy our application as container 
4- copying the previously downloaded jar file to bin dir -> it is needed for making this ec2 as jenkins slave later 
5- finally install git , we gonna need it in another pipline cuase it will be executed from the slave ec2 instance to deploy the application on it 
   briefly * the slave would act as a master that connect with git repo and deploy the application on its docker run time environement  *


# terraform code to build our infrastructure on aws  
1- create 2 subnets , public and private one 
2- public subnet would have the bastion host 
3- private would have the private instance , rds and elastic casch which are required to run our app 
4- private security group would have ports 22,80,443,3000,3306 and 6379 ingress for various purposes such as ssh,http, rds and elastic cash ports handlig comin request of application pod
5- external load balancer existes on public subnet and targeting private instance on port 80 *so that we opened port 80 on private subnet * and listen to incomin traffic on LP dns as http from port 80 that opened on public security group  


# SSH Proxy Command : Going through one host to reach another server 


