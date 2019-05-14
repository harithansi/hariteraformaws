############ Variable for teraform ############
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {
 build = "test1"
 }
 #############################################
 ###### Provider #############################
 # Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-2"
}

###############################################
######## resources ############################
####### Security group for EC2 instance #####

resource "aws_security_group" "nginx_sg" {
  name        = "nginx_sg"
  description = "It is used for engine x security group"

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
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

############# Resource for EC2 instance and attaching SG to EC2 instance ######
###############################################################################
resource "aws_instance" "nginx" {
  ami           = "ami-c58c1dd3"
  instance_type = "t2.micro"
  key_name        = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.nginx_sg.id}"]

  connection {
    user        = "ec2-user"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start"
    ]
  }
}
