output "VPC_ID" {
  value = ["${aws_vpc.new_vpc.id}"]
}

output "EC2_Public_IP" {
  value = ["${aws_instance.node.*.public_ip}"]
}
