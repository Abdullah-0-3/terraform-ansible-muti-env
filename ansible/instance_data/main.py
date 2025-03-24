import boto3
import os
import sys

def parse_arguments():
    if len(sys.argv) < 2:
        print("Error: Please specify an environment.")
        print("Usage: python instance_data.py <environment>")
        print("Example: python instance_data.py dev")
        sys.exit(1)
    
    return sys.argv[1]

def initialize_ec2_client(region):
    return boto3.resource('ec2', region_name=region)

def get_instance_data(ec2_client, environment):
    instances = ec2_client.instances.filter(
        Filters=[
            {'Name': 'tag:Environment', 'Values': [environment]},
            {'Name': 'instance-state-name', 'Values': ['running']}
        ]
    )
    
    return [
        {'instance_id': instance.id, 'public_ip': instance.public_ip_address}
        for instance in instances
        if instance.public_ip_address
    ]

def build_inventory_content(environment, instance_ips, ssh_key_path, python_interpreter):
    inventory_lines = ["[servers]"]
    
    for i, instance in enumerate(instance_ips, 1):
        inventory_lines.append(f"server{i} ansible_host={instance['public_ip']} ansible_user=ubuntu")
    
    inventory_lines.extend([
        "\n[servers:vars]",
        f"ansible_ssh_private_key_file={ssh_key_path}",
        f"ansible_python_interpreter={python_interpreter}"
    ])
    
    return "\n".join(inventory_lines)

def get_inventory_file_path(environment):
    inventory_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "inventory")
    os.makedirs(inventory_dir, exist_ok=True)
    return os.path.join(inventory_dir, f"{environment}.ini")

def write_inventory_file(file_path, content):
    with open(file_path, 'w') as inventory_file:
        inventory_file.write(content)

def get_ssh_key_path():
    # Updated path for correct reference from new location
    return os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "keys", "multi-env-keypair")

def main():
    environment = parse_arguments()
    region = "us-west-2"
    ssh_key_path = get_ssh_key_path()
    python_interpreter = "/usr/bin/python3"
    
    ec2_client = initialize_ec2_client(region)
    instance_ips = get_instance_data(ec2_client, environment)
    inventory_content = build_inventory_content(environment, instance_ips, ssh_key_path, python_interpreter)
    inventory_file_path = get_inventory_file_path(environment)
    write_inventory_file(inventory_file_path, inventory_content)

if __name__ == "__main__":
    main()
