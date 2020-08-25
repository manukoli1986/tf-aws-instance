output "ec2" {
  value = "${module.ec2instance.ec2_public_ip}"
  #module.<MODULE NAME>.<OUTPUT NAME>
}


output "sg_values" {
    value = "${module.sg_import.sg_output}"
}