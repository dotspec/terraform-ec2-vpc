variable "vpc_cidr_block" { }
#variable "vpc_domain_name" { }
#variable "vpc_domain_name_servers" { type = "list" }
variable "vpc_name_tag" { }
variable "private_subnets" { type = "list" }
variable "avail_zones" { type = "list"  }

resource "aws_vpc" "ec2_vpc" {
  cidr_block = "${var.vpc_cidr_block}"

  tags {
    Name = "${var.vpc_name_tag}"
  }
}

resource "aws_internet_gateway" "ec2_igw" {
  vpc_id = "${aws_vpc.ec2_vpc.id}"

  tags {
    Name = "${var.vpc_name_tag}-IGW"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = "${aws_vpc.ec2_vpc.id}"
  cidr_block        = "${var.private_subnets[count.index]}"
  availability_zone = "${var.avail_zones[count.index]}"
  count             = "${length(var.private_subnets)}"

  tags {
    Name = "${vpc_name_tag}-subnet-private-${element(var.avail_zones, count.index)}"
  }
}

/*
resource "aws_route_table" "ec2_route_table" {
  vpc_id = "${aws_vpc.ec2_vpc.id}"
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
