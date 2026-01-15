data "cloudinit_config" "content" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content = yamlencode({
      write_files = [
        {
          path = "/tmp/index.html"
          content = templatefile("${path.module}/web/index.html", {
            page_title = var.page_title
            logo_url   = var.image_url
          })
        },
        {
          path    = "/tmp/style.css"
          content = file("${path.module}/web/style.css")
        }
      ]
    })
  }

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/web/boot.sh")
  }
}

# VM Configs
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.vm_type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  user_data                   = data.cloudinit_config.content.rendered
  key_name                    = aws_key_pair.simple_kp.key_name
  security_groups             = [aws_security_group.allow_web_traffic.id]

  tags = {
    Name = "${var.prefix}-simplec2"
  }
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "simple_kp" {
  key_name   = "${var.prefix}-simplekp"
  public_key = tls_private_key.rsa.public_key_openssh
}