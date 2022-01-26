terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = ">= 1.1.0"
  cloud {
    organization = "techsoysauce"

    workspaces {
      name = "ec2-api"
    }
  }
}

#random comment

provider "aws" {
  region = "us-east-1"
}


#Setup EC2 instance with Flask app and inject $api_version variable
resource "aws_instance" "web" {
  ami                    = "ami-08e4e35cccc6189f4"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data              = templatefile("user_data.tftpl", { version = var.api_version })

  key_name = "ec2sshkey"
}


#Configure SSH key for EC2 access
resource "aws_key_pair" "deployer" {
  key_name   = "ec2sshkey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC87EICYX4gKei7EZ0YjBpmzAkuRXEvRI1LupkQ9M3FAFK35bHgxLviea1Z/msTPYvVecq7KO09ck0wYlL5peDx4g5wCZBl3NhWAj8o8MlWQots6RbMIRApBSCS600lz/AQu9rOl1wB6B0gl+hE5XeqTnnKXRvgnDPuR0lp28J1NJvB4f5kyAxndGMxVIS3fQHrzDWtt6UFWvrxmUpAOPBnBLi1SJps9R7RkbpdLVAyj8Jaq+lrbNeGd0c3FcyZ97AXdT5SkCNEeEc3B6oMlm8pnOYWqPnPk9B1yQluYVGMAUJRIJ4R9BeeKYfVwfDSu9LAm/ruproPa/xMadOzkYmL jose@Ubuntu20LTS"
}


#Configure security group
resource "aws_security_group" "web-sg" {
  name = "web-server-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


#Output public DNS address of EC2 instance
output "web-address" {
  value = aws_instance.web.public_dns
}

