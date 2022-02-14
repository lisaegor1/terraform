provider "aws" {
  region                  = "eu-north-1"
  shared_credentials_file = "/home/yehor/Users/tf_user/.aws/creds"
  #export AWS_ACCESS_KEY_ID=
  #export AWS_SECRET_ACCESS_KEY=
}


resource "aws_instance" "ubuntu123" {
  ami           = "ami-0bd9c26722573e69b"
  instance_type = "t3.micro"
  #count = "  " ~  kolichestvo
  #want to destroy --> jest cut part of the code
  #terraform destroy --> everything in the project folder

  tags = {
    Name    = "ubuntu123"
    Owner   = "Yehor"
    Project = "terra test"
  }
}
