# Create an Application Load Balancer
resource "aws_lb" "fbayomide-lb" {
  name               = "fbayomide-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.fbayomide-lb-sg.id]
  subnets            = [aws_subnet.fbayomide-public-subnet1.id, aws_subnet.fbayomide-public-subnet2.id]
  #enable_cross_zone_load_balancing = true
  enable_deletion_protection = false
  depends_on                 = [aws_instance.fbayomide-server1, aws_instance.fbayomide-server2, aws_instance.fbayomide-server3]
}

# Create the target group
resource "aws_lb_target_group" "fbayomide-tg" {
  name     = "fbayomide-tg"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.fbayomide-vpc.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Create the listener
resource "aws_lb_listener" "fbayomide-lb-listener" {
  load_balancer_arn = aws_lb.fbayomide-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fbayomide-tg.arn
  }
}
# Create the listener rule
resource "aws_lb_listener_rule" "fbayomide-lb-listener-rule" {
  listener_arn = aws_lb_listener.fbayomide-lb-listener.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fbayomide-tg.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

# Attach the target group to the load balancer
resource "aws_lb_target_group_attachment" "fbayomide-tg-attachment1" {
  target_group_arn = aws_lb_target_group.fbayomide-tg.arn
  target_id        = aws_instance.fbayomide-server1.id
  port             = 80
}
 
resource "aws_lb_target_group_attachment" "fbayomide-tg-attachment2" {
  target_group_arn = aws_lb_target_group.fbayomide-tg.arn
  target_id        = aws_instance.fbayomide-server2.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "fbayomide-tg-attachment3" {
  target_group_arn = aws_lb_target_group.fbayomide-tg.arn
  target_id        = aws_instance.fbayomide-server3.id
  port             = 80 
  
  }