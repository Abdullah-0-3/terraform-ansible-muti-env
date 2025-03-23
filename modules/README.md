# Terraform Modules

This directory contains custom Terraform modules used in the multi-environment infrastructure setup.

## Available Modules

### ansible-master

A module that creates an Ansible master instance with necessary configurations.

#### Files:

- `main.tf` - Defines the AWS EC2 instance for Ansible master
- `variables.tf` - Input variables for customizing the Ansible master
- `outputs.tf` - Outputs for accessing instance details

#### Usage:

```terraform
module "ansible_master" {
  source = "../modules/ansible-master"

  name                   = "ansible-master"
  ami_id                 = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.example.id]
  environment            = "dev"
}
```

#### Inputs:

| Name | Description | Type | Default |
|------|-------------|------|---------|
| name | Name of the instance | string | "ansible-master" |
| ami_id | AMI ID to use for the instance | string | - |
| instance_type | Instance type for the Ansible master | string | - |
| key_name | Key pair name for SSH access | string | - |
| vpc_security_group_ids | List of security group IDs | list(string) | - |
| environment | Environment tag value | string | "dev" |

#### Outputs:

| Name | Description |
|------|-------------|
| instance_id | ID of the Ansible master instance |
| public_ip | Public IP of the Ansible master instance |
| private_ip | Private IP of the Ansible master instance |

## Creating New Modules

When creating new modules, follow these guidelines:

1. Create a new directory with a descriptive name
2. Include the following files:
   - `main.tf` - Primary resource definitions
   - `variables.tf` - Input variables
   - `outputs.tf` - Output values
   - `README.md` (optional) - Module documentation

3. Use consistent naming conventions
4. Document all variables and outputs
5. Include examples in module documentation
