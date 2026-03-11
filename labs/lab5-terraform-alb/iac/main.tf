resource "aws_lb" "web_alb" {
  name               = "portfolio-web-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [var.public_subnet_id]
}

resource "aws_lb_target_group" "web_tg" {
  name     = "portfolio-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}
