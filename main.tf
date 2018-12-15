provider "aws" {
    access_key = "${var.accesskey}"
    secret_key = "${var.secretkey}"
    region = "ap-southeast-1"
  }
  resource "aws_security_group" "allow" {
  name        = "allow"
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
    Name = "allow"
  }
}
resource "aws_instance" "aws" {
  ami = "ami-037833522da1d1619"
  key_name = "ramana"
  instance_type = "t2.micro" 
  vpc_security_group_ids = ["${aws_security_group.allow.id}"] 

  connection {
    user = "ubuntu"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "local-exec" {
    inline = [
        "apt-get install git -y",
        "git clone https://github.com/ramana152/terraform.git",
        "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i /home/ubuntu/terraform/hosts /home/ubuntu/terraform/tomcat7.yml",
        ]
  }

}