provider "aws" {
  region   = "us-east-1"
  shared_credentials_file = "/Users/Argedor/.aws/credentials"
  profile = "default"
}

data "aws_subnet_ids" "example" {
  vpc_id = "vpc-ec818296"

}

data "aws_subnet" "example" {
  for_each = data.aws_subnet_ids.example.ids
  id       = each.value
}

output "subnet_ids" {
  value = [for s in data.aws_subnet_ids.example.ids : s] #iterated over a list of subnet_ids and printed them
} 

# resource "aws_instance" "app" {
#   for_each      = data.aws_subnet_ids.example.ids
#   ami           = "ami-0742b4e673072066f"
#   instance_type = "t2.micro"
#   subnet_id     = each.value
# }