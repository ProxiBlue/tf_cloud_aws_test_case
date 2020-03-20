provider "aws" {}

resource "aws_instance" "linux" {
  ami           = "ami-099fd1de9981c9ef5"
  instance_type = "t2.micro"
  availability_zone = "ap-southeast-2a"
  user_data = data.template_file.installation_template.rendered
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "linuxbox2" {
  ami           = "ami-099fd1de9981c9ef5"
  instance_type = "t2.micro"
  availability_zone = "ap-southeast-2a"
  user_data = data.template_file.installation_template.rendered
  lifecycle {
    create_before_destroy = true
  }
  provisioner "file" {
    source      = "configs/ssl-params.conf"
    destination = "/tmp/ssl-params.conf"
    connection {
      type     = "ssh"
      user     = "ubuntu"
      host     = self.public_ip
    }
  }
}


data "template_file" "installation_template" {
  template = "${file("install.tpl")}"
  vars = {
    efs_dns = "www.example.com"
  }
}





