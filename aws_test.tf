provider "aws" {}

resource "aws_instance" "linux" {
  ami           = "ami-099fd1de9981c9ef5"
  instance_type = "t2.micro"
  availability_zone = "ap-southeast-2a"
  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "installation_template" {
  template = "${file("install.tpl")}"
  vars = {
    efs_dns = "www.example.com"
  }
}





