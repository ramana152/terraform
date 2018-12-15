provider "aws" {
    access_key = "${var.accesskey}"
    secret_key = "${var.secretkey}"
    region = "ap-southeast-1"
  }
  resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_all"
  }
}
resource "aws_instance" "aws" {
  ami = "ami-037833522da1d1619"
  key_name = "ramana"
  instance_type = "t2.micro" 
  vpc_security_group_ids = ["${aws_security_group.allow_all.id}"] 

  connection {
    user = "ubuntu"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
        "apt-get install git -y"
        "git clone https://github.com/ramana152/terraform.git",
        "ansible-playbook -i ./terraform/hosts ./terraform/tomcat7.yml",
        ]
  }

}