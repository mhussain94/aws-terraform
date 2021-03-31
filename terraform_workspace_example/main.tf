provider "aws" {
  region   = "eu-west-1"
  shared_credentials_file = "/Users/Argedor/.aws/credentials"
  profile = "default"
}


module "sg_module" {
    source = "./sg_module"
}

module "shared_vars" {
    source = "./shared_vars"
}

module "ec2_module_0" {
    sg_id = "${module.sg_module.sg_id_output}"
    source = "./ec2_module"
}

# returns a variable with the name of the workspace
locals {
    env = "${terraform.workspace}"

    amiid_env={ #map of values
        default = "amiid_default"
        staging = "amiid_staging"
        production = "amiid_production"
    }
    amiid = "${lookup(local.amiid_env, local.env)}" # compares with the map of amiids and the env variable
}

output "envspecific_amiid" {
    value = "${local.amiid}"
}