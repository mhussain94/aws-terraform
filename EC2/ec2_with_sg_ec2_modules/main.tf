provider "aws" {
  region   = "eu-west-1"
  shared_credentials_file = "/Users/Argedor/.aws/credentials"
  profile = "default"
}


module "sg_module" {
    source = "./sg_module"
}

# Creating multiple resources using the same modules
module "ec2_module_0" {
    sg_id = "${module.sg_module.sg_id_output}"
    ec2_name = "Testing variable server0"
    source = "./ec2_module"
}

module "ec2_module_1" {
    sg_id = "${module.sg_module.sg_id_output}"
    ec2_name = "Testing variable server1"
    source = "./ec2_module"
}

module "ec2_module_2" {
    sg_id = "${module.sg_module.sg_id_output}"
    ec2_name = "Testing variable server2"
    source = "./ec2_module"
}