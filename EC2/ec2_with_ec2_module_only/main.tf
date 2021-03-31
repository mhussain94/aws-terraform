provider "aws" {
  region   = "eu-west-1"
  shared_credentials_file = "/Users/Argedor/.aws/credentials"
  profile = "default"
}

module "ec2_module" {
    source = "./module"
}