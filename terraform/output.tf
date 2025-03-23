output "instance_ip" {
  value = {
    for k, instance in module.ec2_instance : k => {
      name = instance.tags_all["Name"]
      public_ip = instance.public_ip
      private_ip = instance.private_ip
    }
  }
}