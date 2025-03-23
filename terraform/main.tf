resource "aws_key_pair" "multi-env-keypair" {
    key_name   = "${local.env}-multi-env-keypair"
    public_key = file("../keys/multi-env-keypair.pub")
}

data "aws_vpc" "default" {
    default = true
}

resource "aws_security_group" "multi-env-security-group" {
  vpc_id = data.aws_vpc.default.id
  name = "multi-env-security-group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["one", "two"])

  name = "${local.env}-instance-${each.key}"
  ami = data.aws_ami.ubuntu.id

  instance_type          = local.env == "prd" ? local.instance_type_b : local.instance_type_a
  key_name               = aws_key_pair.multi-env-keypair.key_name
  vpc_security_group_ids = [aws_security_group.multi-env-security-group.id]

  root_block_device = [
    {
      volume_size = local.env == "prd" ? local.volume_size_b : local.volume_size_a
      volume_type = "gp2"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = local.env
  }
}