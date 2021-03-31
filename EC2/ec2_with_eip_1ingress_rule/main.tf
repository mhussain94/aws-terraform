provider "aws" {
  region                  = "eu-west-1"
  shared_credentials_file = "/Users/Argedor/.aws/credentials"
  profile                 = "default"
}

locals {
  key_pair = "tf_test"
}

resource "aws_security_group" "example2sg" {
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_instance" {
  ami                    = "ami-0fc970315c2d38f01"
  instance_type          = "t2.large"
  vpc_security_group_ids = ["${aws_security_group.example2sg.id}"]
  key_name               = "${local.key_pair}"
  tags = {
    Name = "my-first-ec2-instance"
  }
}

resource "aws_eip" "eip_test" { 
  instance = aws_instance.ec2_instance.id
  vpc      = true
}