terraform {
  backend "s3" {
    bucket         = "jenkins-task-s3"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "jenkins-task"
  }
}
