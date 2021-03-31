#####VARIABLES OUPUT TO BE USED IN OTHER MODULES

output "vpcid" {
    value = "${local.vpcid}"
}
output "publicsubnetid1" {
    value = "${local.publicsubnetid1}"
}
output "publicsubnetid2" {
    value = "${local.publicsubnetid2}"
}
output "privatesubnetid" {
    value = "${local.privatesubnetid}"
}
output "env_suffix" {
    value = "${local.env}"
}


locals {
    env = "${terraform.workspace}"
    
    vpcid_env = {
        default = "vpc-24b1535d"
        staging = "vpc-24b1535d"
        production = "vpc-24b1535d"
    }
    vpcid = "${lookup(local.vpcid_env, local.env)}"

    publicsubnetid1_env = {
        default = "subnet-8c960fd6"
        staging = "subnet-8c960fd6"
        production = "subnet-8c960fd6"
    }
    publicsubnetid1 = "${lookup(local.publicsubnetid1_env, local.env)}"

    publicsubnetid2_env = {
        default = "subnet-c0d589a6"
        staging = "subnet-c0d589a6"
        production = "subnet-c0d589a6"
    }
    publicsubnetid2 = "${lookup(local.publicsubnetid2_env, local.env)}"

    privatesubnetid_env = {
        default = "subnet-c7331c8f"
        staging = "subnet-c7331c8f"
        production = "subnet-c7331c8f"
    }
    privatesubnetid = "${lookup(local.privatesubnetid_env, local.env)}"

}