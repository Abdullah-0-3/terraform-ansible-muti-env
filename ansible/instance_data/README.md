# AWS EC2 Inventory Generator

## Purpose
This script automatically generates Ansible inventory files from EC2 instances based on their environment tags.

## Usage
Run with environment parameter:
```bash
python main.py <environment>
```

**Example:**
```bash
python main.py dev
```

## Function Reference

| Function | Description |
|----------|-------------|
| `parse_arguments()` | Validates command-line parameters and displays usage help when needed |
| `initialize_ec2_client(region)` | Sets up the AWS EC2 client for the specified region |
| `get_instance_data(ec2_client, environment)` | Retrieves running EC2 instances matching the environment tag |
| `build_inventory_content(environment, instance_ips, ssh_key_path, python_interpreter)` | Constructs the Ansible inventory file content with correct format |
| `get_inventory_file_path(environment)` | Determines inventory file location and creates directories as needed |
| `write_inventory_file(file_path, content)` | Writes inventory content to the destination file |
| `get_ssh_key_path()` | Calculates the relative path to the SSH private key |
| `main()` | Orchestrates the entire process from input arguments to file creation |

## Requirements

* **Python Libraries**:
  * boto3 - AWS SDK for Python
  * os, sys - Standard libraries

* **AWS Configuration**:
  * Valid AWS credentials must be configured
  * Instances must have the "Environment" tag

## Output Format

The script creates an inventory file with the following structure:

```ini
[environment-servers]
server1 ansible_host=1.2.3.4 ansible_user=ubuntu
server2 ansible_host=5.6.7.8 ansible_user=ubuntu

[environment-servers:vars]
ansible_ssh_private_key_file=/path/to/key
ansible_python_interpreter=/usr/bin/python3
```

## Notes

* **Silent Operation**: No console output is produced on success
* **Error Handling**: Friendly error messages display when parameters are missing
* **File Location**: Inventory files are created in `ansible/inventory/` directory
* **Supported Environments**: dev, stg, prd (or any environment tag in your AWS account)
