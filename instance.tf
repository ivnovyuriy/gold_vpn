resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYPFqcQsG9RwhMmSW3erVS4b7DghlW7jo8lZo3c8Ja5WaESiUysWKDd8IOgcNv0gV7voE7hVomkIKxpEPyMS8xHGnXQ9/3oZuuI1dBM4WYi4gyLQxQoAgGht50JKTd0eJ3eQQWUIf2VAvRzvw3F8yU/I9UZwddf452Jl5MhLAK9NphqPyxPMMGmPkukFwNa2l7EsnYtt0E7aKNiksZrLlj+w8qmGGCTPYFcaPrTdDhC89/cspZiU+ADBmkwsJflZLShSooDJj8ZSZwCqe8zbkc2tfjqK2VhDNwkrj9wLevcMytpVLclE/Qqa3k90IEROn0cJx5WpZPZdG3d2VvdAqldQ9qIneJ6moE02adi49SCAZ6wlgJSQwb0fkxwb3euBExI3iGWL9fdqlroxmN2WKo3yU0Xu30mtGHfJJpRZ/u1V1r+HKox/OapM9CskvcIsjuMCXalcoM1ut+yNOLitBSrX3f64Xz/8LqIc6RwBhh8biy8CymzGL7j2KmexKROkc= alexey@razer"
}


# Create EC2 instance

resource "aws_instance" "vpn-server" {

  ami                    = var.AMIS[var.AWS_REGION]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main_public_1.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = aws_key_pair.mykey.key_name
  private_ip             = "10.0.1.100"
  tags = {
      Name = "VPN-Server"
  }
  # Declaring the first provisioner that provision the vpn-server installation file to /tmp director

}


resource "null_resource" "vpn-server" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    vpn_server_id = aws_instance.vpn-server.id
  }

  provisioner "file" {
    source      = "vpnserver_setup/setup.sh"
    destination = "/tmp/setup.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("yuriy_ec2.pem")
      host        = aws_instance.vpn-server.public_ip
    }
  }


  # Declaring the provisioner that start installing vpn server and all dependencies

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "sudo /tmp/setup.sh",
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("yuriy_ec2.pem")
      host        = aws_instance.vpn-server.public_ip
    }
  }

}


output "instances" {
  value       = aws_instance.vpn-server.public_ip
  description = "PublicIP address details"
}