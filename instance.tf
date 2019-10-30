resource "aws_key_pair" "deployer" {
  key_name = "${var.key_name}"
  public_key = "${file("/vagrant/mayank-user.pub")}"
}


resource "aws_instance" "Test-VM" {
  ami = "ami-0b69ea66ff7391e80"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  security_groups = ["All_traffic"]
  tags = {
    Name= "Test-VM"
  }

  provisioner "file" {
    source = "./httpd.sh"
    destination  = "/tmp/httpd.sh"
    connection {
        type     = "ssh"
        host     = "${self.public_ip}"
        user     = "${var.user}"
        private_key = "${file("/vagrant/mayank-user")}"
	timeout  = "2m"
    }
  }

  provisioner "remote-exec" {
    inline = [
        "sudo amazon-linux-extras install docker -y", 
	"sudo systemctl start docker",
	"sudo systemctl enable docker",
 	"sudo sh +x /tmp/httpd.sh"]
    connection {
        type     = "ssh"
        host     = "${self.public_ip}"
        user     = "${var.user}"
        private_key = "${file("/vagrant/mayank-user")}"
	timeout	 = "2m"
    }
  }
}



output "ec2_global_ips" {
  value = ["${aws_instance.Test-VM.*.public_ip}"]
}

