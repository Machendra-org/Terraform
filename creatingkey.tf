resource "tls_private_key" "terramachi" {
  algorithm = "RSA"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "terramachi"
  public_key = tls_private_key.terramachi.public_key_openssh
}
