variable "publicsg_id" {}

module "shared_vars" {
    source = "../shared_vars"
}

#Creating LB, first step
resource "aws_lb" "sample_app_alb" {
  name               = "sample-app-alb-${module.shared_vars.env_suffix}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.publicsg_id}"]
  subnets            = ["${module.shared_vars.publicsubnetid1}", "${module.shared_vars.publicsubnetid2}"]

  enable_deletion_protection = false

  tags = {
    Environment = "${module.shared_vars.env_suffix}"
  }
}

#Creating TG, second step
resource "aws_lb_target_group" "sample_app_http_target" {
  name     = "sample-app-http-target-${module.shared_vars.env_suffix}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${module.shared_vars.vpcid}"
  health_check {
    path = "/index.html"
    interval = 5
    timeout = 4
    healthy_threshold = 2
    unhealthy_threshold = 10
  }
}

output "tg_arn" {
  value = "${aws_lb_target_group.sample_app_http_target.arn}"
}

#Creating Listener, third step
resource "aws_lb_listener" "http_listener_80" {
  load_balancer_arn = "${aws_lb.sample_app_alb.arn}"
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #create certificate for domain if needed
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.sample_app_http_target.arn}"
  }
}
