provider "aws" {
  shared_credentials_file = "/home/yehor/Users/tf_user/.aws/creds"
  #Add a static file with credentials/region on the system -> use them to autificate
  region = "eu-north-1"
  #export AWS_ACCESS_KEY_ID=
  #export AWS_SECRET_ACCESS_KEY=
}

resource "aws_instance" "ubuntu123" {
  ami           = "ami-0bd9c26722573e69b"
  instance_type = "t3.micro"

  tags = {
    Name    = "ubuntu123"
    Owner   = "Yehor"
    Project = "terra test"
  }
}

resource "aws_instance" "ubuntu_db" {
  ami           = "ami-0bd9c26722573e69b"
  instance_type = "t3.micro"



  tags = {
    Name    = "ubuntu_db"
    Owner   = "Yehor"
    Project = "terra test"
  }

  depends_on = [aws_instance.ubuntu123]

}
