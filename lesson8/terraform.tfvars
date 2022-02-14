
/* Template of variables for variouse nv.
prod, test , release

auto replace of variables in  file variable.tf
*    .tfvars     !!!!!

region = "ca-central-1"
type   = "t2.micro"

allow_ports = ["228", "333", "556"]

common_tags = {
  Owner       = "ABOBA"
  Project     = "PENTAGON"
  Environment = "SUPER_MEGA_DEPLOY"
}
