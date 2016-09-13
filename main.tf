variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "key_name" {
  default = "elk-test"
}

variable "ssh_user_name" {
  default = "centos"
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "default" {
  name = "default-elk-test"
  description = "default security group for elk-test"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 5601
    to_port = 5601
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "elk" {
  ami = "ami-6d1c2007"
  instance_type = "m3.medium"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id = "${aws_subnet.default.id}"
  key_name = "${aws_key_pair.auth.id}"

  root_block_device {
    delete_on_termination = true
  }

  connection {
    user = "${var.ssh_user_name}"
  }

  provisioner "file" {
    source = "./converge"
    destination = "/home/${var.ssh_user_name}/converge"
  }

  provisioner "converge" {
    params = {
      docker-group-user-name = "${var.ssh_user_name}"
    }
    modules = [
      "converge/elk.hcl"
    ]
    download_binary = true
    prevent_sudo = false
  }
}

output "ip" {
  value = "${aws_instance.elk.public_ip}"
}
