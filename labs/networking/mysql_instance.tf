data "aws_ami" "linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # AWS
}

resource "aws_instance" "lab" {
  ami                    = data.aws_ami.linux_2.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.this.id]
  subnet_id              = aws_subnet.this.id
  iam_instance_profile   = aws_iam_instance_profile.this.id
  key_name               = aws_key_pair.mysql.key_name

  tags = {
    Name = "is311-networking-mysql-server"
  }

  # Credits to @ryanpric for most of this
  # Now provision the instance with local Minecraft files & the init script
  connection {
    host        = self.public_ip # instead of EIP, since that won't be assigned until after all provisioners run
    private_key = tls_private_key.mysql.private_key_pem
    user        = "ec2-user"
  }


  provisioner "file" {
    source      = "data" # a directory
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo -E bash /tmp/data/init.sh"
    ]
  }
}

resource "aws_key_pair" "mysql" {
  key_name   = "mysql_kp"
  public_key = tls_private_key.mysql.public_key_openssh
}

resource "tls_private_key" "mysql" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
