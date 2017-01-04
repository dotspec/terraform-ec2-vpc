variable "vpc_cidr_block" { }
#variable "vpc_domain_name" { }
#variable "vpc_domain_name_servers" { type = "list" }
variable "vpc_name_tag" { }

resource "aws_vpc" "ec2_vpc" {
  cidr_block = "${var.vpc_cidr_block}"

  tags {
    Name = "${var.vpc_name_tag}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.ec2_vpc.id}"
  
  tags {
    Name = "${var.vpc_name_tag}"
  }
}

/*resource "aws_vpc_dhcp_options" "ec2_vpc_dhcp_options" {


}*/

/*resource "aws_vpc_dhcp_options_association" "ec2_vpc_dhcp_options_association" {
  vpc_id          = "${aws_vpc.ec2_vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.ec2_vpc_dhcp_options.id}"
}

resource "aws_internet_gateway" "ec2_vpc_internet_gateway" {
  vpc_id = "${aws_vpc.ec2_vpc.id}"
}*/
