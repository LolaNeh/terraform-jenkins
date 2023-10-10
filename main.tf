#Security group inbound traffic 
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-06848deca49c9e2b1"

  ingress {
    description      = "TLS from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

#ec2 instance provisions
resource "aws_instance" "jenkins_instance" {
  ami           = "ami-08d5c2c27495d734a"
  instance_type = "t2.small"
  subnet_id = "subnet-004813b02e5e26cf3"
  associate_public_ip_address = true
  security_groups = [aws_security_group.jenkins_sg.name] 
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
  }
  
}
resource "tls_private_key" "EC2-keypair" {
  algorithm = "RSA"
  rsa_bits  = 2048

}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  key_name   = "my-EC2-keypair"
  public_key = tls_private_key.EC2-keypair.public_key_openssh
}



# print the ssh remote connection command
output "jenkins_public_ip" {
  value = "aws_instance.jenkins_instance.public_ip"
}

