resource "aws_launch_template" "blue" {
  name          = "cmtr-uad9vkoz-blue-template"
  instance_type = "t3.micro"
  image_id      = data.aws_ami.amazon_linux.id

  network_interfaces {
    security_groups = [
      data.aws_security_group.SSH_access.id,
      data.aws_security_group.HTTP_access_to_EC2.id
    ]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd
    echo "<h1>Blue Environment</h1>" > /var/www/html/index.html
    EOF
  )
}
resource "aws_launch_template" "green" {
  name          = "cmtr-uad9vkoz-green-template"
  instance_type = "t3.micro"
  image_id      = data.aws_ami.amazon_linux.id

  network_interfaces {
    security_groups = [
      data.aws_security_group.SSH_access.id,
      data.aws_security_group.HTTP_access_to_EC2.id
    ]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd
    echo "<h1>Green Environment</h1>" > /var/www/html/index.html
    EOF
  )
}
resource "aws_lb_target_group" "blue" {
  name     = "cmtr-uad9vkoz-blue-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id
}

resource "aws_lb_target_group" "green" {
  name     = "cmtr-uad9vkoz-green-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id
}
resource "aws_autoscaling_group" "blue" {
  name                = "cmtr-uad9vkoz-blue-asg"
  desired_capacity    = 1
  min_size            = 1
  max_size            = 2
  vpc_zone_identifier = concat(data.aws_subnets.public_subnet_1.ids, data.aws_subnets.public_subnet_2.ids)
  target_group_arns   = [aws_lb_target_group.blue.arn]

  launch_template {
    id      = aws_launch_template.blue.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "cmtr-uad9vkoz-blue-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "green" {
  name                = "cmtr-uad9vkoz-green-asg"
  desired_capacity    = 1
  min_size            = 1
  max_size            = 2
  vpc_zone_identifier = concat(data.aws_subnets.public_subnet_1.ids, data.aws_subnets.public_subnet_2.ids)
  target_group_arns   = [aws_lb_target_group.green.arn]

  launch_template {
    id      = aws_launch_template.green.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "cmtr-uad9vkoz-green-instance"
    propagate_at_launch = true
  }
}

resource "aws_lb" "lb" {
  name               = "cmtr-uad9vkoz-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.HTTP_access_to_ALB.id]
  subnets            = concat(data.aws_subnets.public_subnet_1.ids, data.aws_subnets.public_subnet_2.ids)
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.blue.arn
        weight = var.blue_weight
      }
      target_group {
        arn    = aws_lb_target_group.green.arn
        weight = var.green_weight
      }
    }
  }
}