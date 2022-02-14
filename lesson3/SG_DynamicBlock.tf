provider "aws" {
  region = "eu-north-1"
}

resource "aws_security_group" "test_dynamic" {
  name        = "TEST_SG_DynamicBlock"
  description = "TEST SG "

  #~~~~~~~~~~~~Dynamic block~~~~~~~~~~~~~#

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
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

  tags = {
    Name = "TEST_SG_DynamicBlock"
  }
}
