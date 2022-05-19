
/* Plugins and tools installed installed 
1- Pipeline AWS steps to use the with
2- cloudBees AWS credentials to save the credentials in jenkins
3- terraform tool
*/ 
pipeline {
  agent any
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
        stage('terraform build'){
          steps{
             withAWS(credentials: 'jenkins-user', region: 'us-west-2') {
         
                sh 'terraform plan --var-file=dev.tfvars'
                //sh 'terraform apply --auto-approve --var-file=dev.tfvars'
                }
          }
        }
    }
     
  }