# Terraform and Ansible Multi-Environment Setup

This project helps you automatically set up infrastructure in AWS for different environments (development, staging, and production) using Terraform and Ansible.

## What This Project Does

- Creates EC2 instances in AWS with different sizes based on environment
- Sets up a single Ansible master server to manage all environments
- Automatically generates inventory files for Ansible based on created instances
- Supports separate configurations for dev, staging, and production environments

## Project Structure

```
terraform-ansible-multi-env/
├── ansible/                  # Ansible configuration and playbooks
│   ├── instance_data/        # Scripts to generate inventory from AWS
│   └── inventory/            # Environment-specific inventory files
├── keys/                     # SSH keys for server access
├── modules/                  # Reusable Terraform modules
│   └── ansible-master/       # Module for creating Ansible control server
└── terraform/                # Terraform configuration files
```

## Getting Started

### Requirements

- AWS account and AWS CLI configured
- Terraform installed (version 1.0+)
- Python installed with boto3 package
- Basic knowledge of Terraform and Ansible

### Setup Steps

1. **Clone this repository**

2. **Set up SSH keys**
   - The project expects SSH keys at `keys/multi-env-keypair`
   - You can use existing keys or generate new ones:
     ```
     ssh-keygen -t ed25519 -f keys/multi-env-keypair
     ```

3. **Choose your environment**
   - Open `terraform/variables.tf`
   - Change the `env` value to:
     - `dev` for development (uses smaller instances)
     - `stg` for staging
     - `prd` for production (uses larger instances)

4. **Deploy infrastructure**
   - Navigate to the terraform directory:
     ```
     cd terraform
     ```
   - Initialize Terraform:
     ```
     terraform init
     ```
   - Deploy:
     ```
     terraform apply
     ```

5. **Generate Ansible inventory**
   - After infrastructure is created, run:
     ```
     cd ../ansible/instance_data
     python main.py dev    # Replace 'dev' with your environment
     ```

## Using the Setup

### Access Servers

- You can SSH into any server using the keypair:
  ```
  ssh -i ../keys/multi-env-keypair ubuntu@[SERVER_IP]
  ```

### Ansible Management

- The Ansible master server is ready to use for configuration management
- Inventory files are in `ansible/inventory/[env].ini`
- Run Ansible commands from the Ansible master

### Clean Up

- To remove all created resources:
  ```
  cd terraform
  terraform destroy
  ```

## Environment Details

- **Development (`dev`)**: Small instances (t2.micro) with 8GB storage
- **Staging (`stg`)**: Small instances (t2.micro) with 8GB storage
- **Production (`prd`)**: Medium instances (t2.medium) with 15GB storage

## Security Notes

- By default, SSH is open to all IPs (0.0.0.0/0)
- For better security, limit this to your IP address
- All infrastructure is created with environment-specific tags

## Need Help?

If you encounter issues:
1. Check AWS credentials are configured correctly
2. Verify Terraform and Python are installed
3. Make sure SSH keys exist in the keys directory
