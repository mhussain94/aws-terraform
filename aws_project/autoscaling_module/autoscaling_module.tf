module "shared_vars" {
    source = "../shared_vars"
}

variable privatesg_id {}
variable tg_arn {}

locals {
    env = "${terraform.workspace}"
    
    amiid_env = {
        default = "ami-0fc970315c2d38f01"
        staging = "ami-0fc970315c2d38f01"
        production = "ami-0fc970315c2d38f01"
    }
    amiid= "${lookup(local.amiid_env, local.env)}"

    instancetype_env = {
        default = "t2.micro"
        staging = "t2.micro"
        production = "t2.medium"
    }
    instancetype= "${lookup(local.instancetype_env, local.env)}"

    keypair_env = {
        default = "tf_test"
        staging = "tf_test"
        production = "tf_test"
    }
    keypair= "${lookup(local.keypair_env, local.env)}"

    asgdesired_env = {
        default = "1"
        staging = "1"
        production = "4"
    }
    asgdesired= "${lookup(local.asgdesired_env, local.env)}"

    asgmin_env = {
        default = "1"
        staging = "1"
        production = "2"
    }
    asgmin= "${lookup(local.asgmin_env, local.env)}"

    asgmax_env = {
        default = "1"
        staging = "2"
        production = "4"
    }
    asgmax= "${lookup(local.asgmax_env, local.env)}"

}

# for autoscalling group, first needed is a launch configuration
resource "aws_launch_configuration" "sampleapp_lc" {
  name          = "sampleapp_lc_${local.env}"
  image_id      = "${local.amiid}"
  instance_type = "${local.instancetype}"
  key_name = "${local.keypair}"
  user_data = "${file("assets/userdata.txt")}"
  security_groups = ["${var.privatesg_id}"]
}

# autoscaling group creation
resource "aws_autoscaling_group" "sample_app_asg" {
  name                      = "sample-app-asg-${module.shared_vars.env_suffix}"
  max_size                  = "${local.asgmax}"
  min_size                  = "${local.asgmin}"
  desired_capacity          = "${local.asgdesired}"
  launch_configuration      = "${aws_launch_configuration.sampleapp_lc.name}"
  vpc_zone_identifier       = ["${module.shared_vars.publicsubnetid1}", "${module.shared_vars.publicsubnetid2}"]
  target_group_arns         = ["${var.tg_arn}"]

  tags = [{
    key                 = "Name"
    value               = "SampleApp_${module.shared_vars.env_suffix}"
    propagate_at_launch = true
  },
  {
    key                 = "Environment"
    value               = "${module.shared_vars.env_suffix}"
    propagate_at_launch = true
  }
  ]
}