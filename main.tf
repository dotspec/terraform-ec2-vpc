variable "vpc_cidr_block" { }
#variable "vpc_domain_name" { }
#variable "vpc_domain_name_servers" { type = "list" }
variable "vpc_name_tag" { }

resource "aws_vpc" "ec2_vpc" {
  cidr_block = "${var.vpc_cidr_block}"
}

resource "aws_vpc_dhcp_options" "ec2_vpc_dhcp_options" {

  tags {
    Name = "${var.vpc_name_tag}"
  }
}

resource "aws_vpc_dhcp_options_association" "ec2_vpc_dhcp_options_association" {
  vpc_id          = "${aws_vpc.ec2_vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.ec2_vpc_dhcp_options.id}"
}

resource "aws_internet_gateway" "ec2_vpc_dhcp_options" {
  vpc_id = "${aws_vpc.ec2_vpc.id}"
}
