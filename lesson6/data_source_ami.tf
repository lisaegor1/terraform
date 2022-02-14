provider "aws" {
  shared_credentials_file = "/home/yehor/Users/tf_user/.aws/creds"
  region                  = "eu-north-1"
}
#dont worry about versions of your instances
#this commands will find the newst
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "ubuntu_latest" {
  ami           = data.aws_ami.latest_ubuntu.id #output value *id
  instance_type = "t3.micro"
}


output "latest_ubuntu_ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}

output "latest_ubuntu_ami_name" {
  value = data.aws_ami.latest_ubuntu.name
}
