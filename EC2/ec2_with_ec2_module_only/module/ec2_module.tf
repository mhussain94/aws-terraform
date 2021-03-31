#default vpc taken from aws console
variable "vpc_id" {
    type= "string"
    default= "vpc-24b1535d"
  
}

# creating security group
resource "aws_security_group" "tf_ec2_sg" {
  name        = "tf_ec2_sg"
  description = "tf sg security group for ec2"
  vpc_id      = "${var.vpc_id}"

  ingress { #inbound
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { #outbound
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

#providing ami
variable "ami_id" {
    default= "ami-0fc970315c2d38f01"
}

#creating instance
resource "aws_instance" "ec2_instance" {
  ami                    = "ami-0fc970315c2d38f01"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.tf_ec2_sg.id}"]
  key_name               = "tf_test"
  tags = {
    Name = "first-ec2-instance"
  }
}

# elastic ip provisioning
resource "aws_eip" "lb" { 
  instance = aws_instance.ec2_instance.id
  vpc      = true
}

