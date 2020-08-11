resource "aws_instance" "node" {
  ami = "ami-0b69ea66ff7391e80"
  instance_type = var.instance_type
  key_name = "${var.key_name}"
  subnet_id   = "${aws_subnet.new_subnet-1.id}"
  vpc_security_group_ids = "${aws_security_group.sg.id}"
  associate_public_ip_address = true
  tags = {
    Name= "Node1"
    Env = "dev"
  }
  provisioner "remote-exec" {
    inline = [
        "sudo yum install docker git -y",
        "git clone https://github.com/manukoli1986/weather_basic_app.git",
        "cd weather_basic_app && python app.py"
        ]
    connection {
        type     = "ssh"
        host     = "${self.public_ip}"
        user     = "${var.user}"
        private_key = "${file(var.aws_existed_key_name)}"
	      timeout	 = "2m"
    }
  }
}