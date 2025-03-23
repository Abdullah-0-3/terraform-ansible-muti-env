# Multi-Environment Infrastructure with Terraform

This Terraform configuration provides infrastructure deployment across multiple environments (dev, staging, and production) with consistent configurations but environment-specific parameters.

## Structure

- `main.tf` - Primary resource definitions
- `variables.tf` - Environment-specific variables and locals
- `providers.tf` - AWS provider configuration
- `data.tf` - Data source definitions
- `output.tf` - Output configurations

## Resources Created

- **EC2 Instances**: Deployed for each environment with appropriate sizing
- **Security Groups**: Controls access to the instances
- **SSH Keys**: Environment-specific SSH key configurations
- **Ansible Master**: Dedicated instance for Ansible automation

## Usage

### Prerequisites

- Terraform v1.0+
- AWS CLI configured with appropriate permissions
- SSH key in `../keys/multi-env-keypair.pub`

### Commands

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Plan the deployment for validation:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. To destroy the infrastructure:
   ```bash
   terraform destroy
   ```

### Environment Management

The environment is controlled through the `local.env` variable in `variables.tf`. Change this value to deploy to different environments:

- `dev` - Development environment (smaller instances)
- `stg` - Staging environment
- `prd` - Production environment (larger instances)

## Outputs

After applying the configuration, the following outputs will be available:

- `instance_ip` - Public and private IPs of the EC2 instances
- `ansible_master_public_ip` - Public IP of the Ansible master
- `ansible_master_private_ip` - Private IP of the Ansible master
- `ansible_master_public_dns` - Public DNS name of the Ansible master
- `ansible_master_instance_id` - Instance ID of the Ansible master

## Security Considerations

- The configuration includes security groups that allow SSH access from any IP (0.0.0.0/0)
- Consider restricting SSH access to specific IPs for production environments
- Use AWS IAM best practices for managing access to the AWS account
