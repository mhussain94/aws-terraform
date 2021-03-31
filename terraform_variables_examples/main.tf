provider "aws" {
  region   = "eu-west-1"
  shared_credentials_file = "/Users/Argedor/.aws/credentials"
  profile = "default"
}

//this is a string variable

variable "firststring" {
  type = "string"
  default = "this is my first string"
}

variable "multistring" {
  type = "string"
  default = "this is my first string"
}


variable "multilinestring" {
  type = "string"
  default = <<EOH
  this is a multiline
  string
  newline
  EOH
}

output "firstouput" {
  value = "${var.firststring}" #how to input variables in terraform, for maybe userdata scripts
}

// This is my vaps example

variable "mapexample" {
  type = "map"
  default= {
    "useast" = "ami1"
    "euwest" = "ami2"
  }
}

output "mapoutput" {
  value= "${var.mapexample["useast"]}"
}

//this is arraylist

variable "mysecuritygrouplist" {
  type = "list"
  default = ["sg1", "sg2", "sg3"]
}

output "sgoutput" {
  value = "${var.mysecuritygrouplist}"
}

//test boolean

variable "testbool" {
  default = false
}

output "booloutput" {
  value = "${var.testbool}"
}

//input testbool

variable "inputvariable" {
  type = "string"
}

output "inputtest" {
  sensitive = true    #making sensitive this output would not be shown
  value = "${var.inputvariable}"
}

#etag check