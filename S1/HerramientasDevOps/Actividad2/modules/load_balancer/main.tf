resource "aws_lb" "app_lb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "app-alb"
  }
}

resource "aws_lb_target_group" "app_lb_tg" {
  name        = "app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path     = "/health"
    protocol = "HTTP"
    matcher  = "200"
  }

  tags = {
    Name = "app-lb-tg"
  }
}

resource "aws_lb_target_group_attachment" "app_lb_tg_attachment" {
  for_each         = var.target_instance_ids
  target_group_arn = aws_lb_target_group.app_lb_tg.arn
  target_id        = each.value
  port             = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_lb_tg.arn
  }
}
