

provider "aws" {
    region = "us-east-1"
    profile = "default"
  
}

resource "aws_instance" "nginx-server" {
    ami           = "ami-0c2b8ca1dad447f8a" # Amazon Linux 2 AMI
    instance_type = "t3.micro"

    user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo amazon-linux-extras install nginx1 -y
                sudo systemctl start nginx
                sudo systemctl enable nginx
                echo "<h1>Welcome to Nginx Server</h1>" | sudo tee /usr/share/nginx/html/index.html
                EOF
    key_name = aws_key_pair.nginx-server-ssh.key_name
        
        vpc_security_group_ids = [aws_security_group.nginx-server-sg.id]

        tags = {
          Name = "nginx-server"
          environment = "test"
          owner = "daniel.i.gallo@gmail.com"
          team = "devops"
          project = "nginx-terraform"
          
          
          }
        
        }


### Security Group to allow HTTP and SSH access
## ssh-keygen -t rsa -b 2048 -f "nginx-server.key"
  resource "aws_key_pair" "nginx-server-ssh" {
    key_name   = "nginx-server-ssh"
    public_key = file ("nginx-server.key.pub")
    
  }

resource "aws_security_group" "nginx-server-sg" {
    name        = "nginx-server-sg"
    description = "Allow HTTP and SSH traffic"

    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  
}

ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]   
    }
  }