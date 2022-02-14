#green/blue deploy
provider "aws" {
  shared_credentials_file = "/home/yehor/Users/tf_user/.aws/creds"
  region                  = "eu-north-1"
}

#----------------Auto-version-------------

data "aws_availability_zones" "available" {}
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

#-------------------SG--------------------

resource "aws_security_group" "SG_for_project" {
  name        = "SG_for_project"
  description = "Security Group for project (lesson#7)"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 23
    to_port     = 23
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 1
    to_port     = 1
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#-----------------launch conf----------
resource "aws_launch_configuration" "project" {
  name            = "Project-HA-LC"
  image_id        = data.aws_ami.latest_ubuntu.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.SG_for_project.id]
  user_data       = file("user_data.sh")

  #--------------------lifecycle--------
  lifecycle {
    create_before_destroy = true
  }
}

#------------Auto scaling_adjustment
resource "aws_autoscaling_group" "ASG_for_project" {
  name                 = "Project-HA-LC"
  launch_configuration = aws_launch_configuration.project.name
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.project-elb.name]

  tag {
    key                 = "Name"
    value               = "WebServer-in-ASG"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "project-elb" {
  name               = "project-elb"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups    = [aws_security_group.SG_for_project.id]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = {
    Name = "ELB_for_Project"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

#--------------------

output "web_loadbalancer_url" {
  value = aws_elb.project-elb.dns_name
}
