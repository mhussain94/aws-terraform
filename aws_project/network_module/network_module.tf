module "shared_vars" {
    source= "../shared_vars"
} 

# the public one is loadbalancers, private one is for the app, and the loadbalancers sg is targetting sg in private one.
# only accessible from the loadbalancer
resource "aws_security_group" "publicsg" {
  name        = "public_${module.shared_vars.env_suffix}" #the ""sg_ec2_${modulde.shared_vars.env_suffix}"" part is getting the environment suffix from shared_vars modul
  description = "public security for ELB example in ${module.shared_vars.env_suffix}"
  vpc_id      = "${module.shared_vars.vpcid}"

  ingress { #inbound
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { #outbound
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "LB_example_sg"
  }
}

resource "aws_security_group" "privatesg" {
  name        = "private_${module.shared_vars.env_suffix}" #the ""sg_ec2_${modulde.shared_vars.env_suffix}"" part is getting the environment suffix from shared_vars modul
  description = "private security for ELB example in ${module.shared_vars.env_suffix}"
  vpc_id      = "${module.shared_vars.vpcid}"

  ingress { #inbound
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.publicsg.id}"] #loadbalancers sg
  }

  egress { #outbound
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_from_LB"
  }
}

output "publicsg_id" {
  value = "${aws_security_group.publicsg.id}"
}

output "privatesg_id" {
  value = "${aws_security_group.privatesg.id}"
}