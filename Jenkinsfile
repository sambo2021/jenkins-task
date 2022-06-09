
/* Plugins and tools installed installed 
1- Pipeline AWS steps to use the with
2- cloudBees AWS credentials to save the credentials in jenkins
3- terraform tool
*/ 
pipeline {
  agent {label '!private_slave'}
    tools {
       terraform 'jenkins-terraform'
    }
  
    stages {
        stage('terraform format') {
            steps{
                withAWS(credentials: 'jenkins-user', region: 'us-west-2') {
                sh 'terraform fmt'
                }
            }
        }
        stage('terraform init'){
          steps{
             withAWS(credentials: 'jenkins-user', region: 'us-west-2') {
                sh 'terraform init'
                // sh 'terraform workspace new dev'
                }
          }
        }
        stage('terraform plan'){
          steps{
             withAWS(credentials: 'jenkins-user', region: 'us-west-2') {
                sh 'terraform plan --var-file=dev.tfvars'
                }
          }
        }
         stage('terraform build'){
          steps{
             withAWS(credentials: 'jenkins-user', region: 'us-west-2') {
                   sh 'terraform apply  --var-file=dev.tfvars --auto-approve'
                   //sh 'terraform destroy  --var-file=dev.tfvars --auto-approve'
                }
          }
        }

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

          stage ("Configure Private Instance With Ansible"){
            steps{
                  sh """
                  ansible-playbook -i Ansible/inventory Ansible/ansible-ec2.yml
                  """
            }
          }

    }
     
  }