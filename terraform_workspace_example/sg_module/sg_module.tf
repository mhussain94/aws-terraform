#default vpc taken from aws console
variable "vpc_id" {
    type= "string"
    default= "vpc-24b1535d"
  
}

#getting the shared variables module here
module "shared_vars" {
  source = "../shared_vars"
}

#Providing a name to the sg
#the ""sg_ec2_${modulde.shared_vars.env_suffix}"" part is getting the environment suffix from shared_vars modul
# creating security group
resource "aws_security_group" "tf_ec2_sg" {
  name        = "sg_ec2_${module.shared_vars.env_suffix}" #the ""sg_ec2_${modulde.shared_vars.env_suffix}"" part is getting the environment suffix from shared_vars modul
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
  value = "${aws_security_group.tf_ec2_sg.id}"
}