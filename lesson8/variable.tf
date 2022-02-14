variable "region" {
  description = "Please enter AWS Region to deploy server"
  default     = "eu-north-1"
}

variable "type" {
  description = "Enter instance type"
  default     = "t3.micro"
}

variable "allow_ports" {
  description = "List of ports"
  type        = list(any)
  default     = ["80", "443", "22"]
}

variable "common_tags" {
  description = "List of default tags for resources"
  type        = map(any)
  default = {
    Owner       = "Yehor"
    Project     = "lesson#8"
    Environment = "test.env"
  }
}
