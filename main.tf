#Security group inbound traffic 
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow TLS inbound traffic"
#   vpc_id      = module "vpc" {
#     source = "terraform-aws-modules/vpc/aws"
    
#   }

  ingress {
    description      = "TLS from VPC for http"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description      = "TLS from VPC for ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
#   ingress {
#     description      = "TLS from VPC"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]

  #}
  egress {
    #description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}
# Generate a secure key using rsa algorithm
resource "tls_private_key" "EC2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048

}
# creating the keypair in aws
resource "aws_key_pair" "EC2_key" {
  key_name   = "my-EC2-keypair"
  public_key = tls_private_key.EC2_key.public_key_openssh
}

# Save the .pem file locally for remote connection
resource "local_file" "ssh_key" {
    filename = "jenkins.pem"
    content = tls_private_key.EC2_key.private_key_pem
}

#ec2 instance provisions
resource "aws_instance" "jenkins_instance" {
  ami           = "ami-0bb4c991fa89d4b9b"
  instance_type = "t2.micro"
  key_name = aws_key_pair.EC2_key.key_name
  security_groups = [aws_security_group.jenkins_sg.name] 
  #subnet_id = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data = file ("jenkins.sh")
#   user_data = <<-EOF
#               #!/bin/bash -x
#               sudo yum update -y
#               sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
#               sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
#               sudo yum upgrade -y

#               ## Install Java 11:
#               sudo yum install java-11* -y

#               ## Install Jenkins then Enable the Jenkins service to start at boot :
#               sudo yum install jenkins -y
#               sudo systemctl enable jenkins

#               ## Start Jenkins as a service:
#               sudo systemctl start jenkins
#               EOF   
  #security_groups_names = [aws_security_group.jenkins_sg.name] 
  tags = {
    Name = "Jenkins Server"
    Env ="Dev"
  }
  
}

# print the ssh remote connection command
output "jenkins_public_ip" {
  value = "aws_instance.jenkins_instance.public_ip"
}

