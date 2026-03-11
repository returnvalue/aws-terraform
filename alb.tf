resource "aws_lb" "web_alb" {
  name               = "portfolio-web-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet.id]
}

resource "aws_lb_target_group" "web_tg" {
  name     = "portfolio-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.portfolio_vpc.id
}
