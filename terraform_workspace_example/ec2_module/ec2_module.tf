#providing ami
variable "ami_id" {
    default= "ami-0fc970315c2d38f01"
}

module "shared_vars" {
  source = "../shared_vars"  
}
variable "sg_id" {}

#creating instance
resource "aws_instance" "ec2_instance" {
  ami                    = "ami-0fc970315c2d38f01"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${var.sg_id}"]
  key_name               = "tf_test"
  tags = {
    Name = "EC2_name_instance_${module.shared_vars.env_suffix}"
  }
}

# elastic ip provisioning
resource "aws_eip" "lb" { 
  instance = aws_instance.ec2_instance.id
  vpc      = true
}

