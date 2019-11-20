resource "aws_key_pair" "deployer" {
  key_name = "${var.key_name}"
  public_key = "${file("/vagrant/mayank-user.pub")}"
}




resource "aws_instance" "cluster" {
  count = 3
  ami = "ami-0b69ea66ff7391e80"
  instance_type = "t2.micro"
  availability_zone  = "${element(var.zones, count.index)}"
  key_name = "${var.key_name}"
  security_groups = ["All_traffic"]
  tags = {
    Name= "Test-VM-${count.index}"
	}

}

######### 
resource "null_resource" "cluster" {

  triggers = {
    cluster_instance_ids = "${join(",", aws_instance.cluster.*.id)}"
  }

############## File to be placed in provisioned EC2 

  provisioner "file" {
    source = "./httpd.sh"
    destination  = "/tmp/httpd.sh"
    connection {
        type     = "ssh"
        host     = "${element(aws_instance.cluster.*.public_ip, count.index + 1)}"
        user     = "${var.user}"
        private_key = "${file("/vagrant/mayank-user")}"
	timeout  = "2m"
    }
  }

############### Install necessary tools to run ansible on provisioned EC2
  provisioner "remote-exec" {
    inline = [
        "sudo amazon-linux-extras install docker -y",
        "sudo yum install python -y", 
	"sudo systemctl start docker",
        "sudo systemctl enable docker"]
    connection {
        type     = "ssh"
        host     = "${element(aws_instance.cluster.*.public_ip, count.index + 1)}"
        user     = "${var.user}"
        private_key = "${file("/vagrant/mayank-user")}"
	timeout	 = "2m"
    }
  }

############ Deploying code on provisioned EC2
  provisioner "local-exec" {
    command = "sleep 10s && ansible-playbook  -u ${var.user} -i '${element(aws_instance.cluster.*.public_ip, count.index + 1)},'  --private-key '${var.priv_key_path}' provision.yml"
  }
}



output "ec2_global_ips" {
  value = ["${aws_instance.cluster.*.public_ip}"]
}

