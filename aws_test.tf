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

resource "tls_private_key" "aws" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "publicaccesskey" {
  key_name = "test-public-ssh-key"
  public_key = tls_private_key.aws.public_key_openssh
}

resource "aws_instance" "linuxbox2" {
  ami           = "ami-099fd1de9981c9ef5"
  instance_type = "t2.micro"
  availability_zone = "ap-southeast-2a"
  user_data = data.template_file.installation_template.rendered
  key_name = aws_key_pair.publicaccesskey.id
  lifecycle {
    create_before_destroy = true
  }
  provisioner "local-exec" {
    command = "echo '${tls_private_key.aws.private_key_pem}' | tr -d '\r' | ssh-add - > /dev/null"
  }
  provisioner "file" {
    source      = "configs/ssl-params.conf"
    destination = "/tmp/ssl-params.conf"
    connection {
      type     = "ssh"
      user     = "ubuntu"
      host     = self.public_ip
      private_key = tls_private_key.aws.private_key_pem
    }
  }
}


data "template_file" "installation_template" {
  template = "${file("install.tpl")}"
  vars = {
    efs_dns = "www.example.com"
  }
}

output "ssh_public_key" {
  value = aws_key_pair.publicaccesskey.public_key
}

output "ssh_private_key_pem" {
  value = tls_private_key.aws.private_key_pem
}





