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

output "sg_id_output" {
  value = "${aws_security_group.tf_ec2_sg.id}" #comes from what the ec2 module needs
}