

provider "aws" {
    region = "us-east-1"
    profile = "default"
  
}

resource "aws_instance" "nginx-server" {
    ami           = "ami-0c2b8ca1dad447f8a" # Amazon Linux 2 AMI
    instance_type = "t3.micro"
  
    }
  
    