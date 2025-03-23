resource "aws_instance" "ansible_master" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids

  root_block_device {
    volume_size = 25
    volume_type = "gp2"
  }

  tags = {
    Name        = var.name
    Terraform   = "true"
    Environment = var.environment
    Role        = "ansible-master"
  }
}
