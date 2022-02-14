provider "aws" {
  shared_credentials_file = "/home/yehor/Users/tf_user/.aws/creds"
  region                  = var.region
}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "ubuntu_var_test" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.type
  vpc_security_group_ids = [aws_security_group.SG_for_var_test.id]
  tags                   = var.common_tags

}

resource "aws_security_group" "SG_for_var_test" {
  name        = "sg_var"
  description = "SG for lesson#8"

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
