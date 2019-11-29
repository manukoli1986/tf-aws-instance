resource "aws_key_pair" "deployer" {
  key_name = "${var.key_name}"
  public_key = "${file("/vagrant/mayank-user.pub")}"
}

########################################################################
### Creating 3 EC2 in multi Az which is listed in variable file. Here 
### 3 EC2 will be created with common security group.
########################################################################
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
######################################################################
#### Null_resource --> The null_resource resource implements the standard resource lifecycle but takes no further action.
#### Trigger -- > The triggers argument allows specifying an arbitrary set of values that, when changed, will cause the resource to be replaced.
#### Element Function --> Will be using to element retrieves a single element from a list. Like index will start from 0.
######################################################################
resource "null_resource" "cluster" {
  count = 3
  triggers = {
    cluster_instance_ids = "${element(aws_instance.cluster.*.id,0)}"
  }
####################################################################
### File to be placed in provisioned EC2 
####################################################################
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

#################################################################
### Print the Public IPs 
################################################################

output "ec2_global_ips" {
  value = ["${aws_instance.cluster.*.public_ip}"]
}

