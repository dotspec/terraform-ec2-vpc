variable "vpc_cidr_block" {}

#variable "vpc_domain_name" { }
#variable "vpc_domain_name_servers" { type = "list" }
variable "vpc_name" {}

variable "private_subnets" {
  type = "list"
}

variable "public_subnets" {
  type = "list"
}

variable "avail_zones" {
  type = "list"
}

variable "public_routes" {
  type = "map"
}

## Resources 

resource "aws_vpc" "ec2_vpc" {
  cidr_block = "${var.vpc_cidr_block}"

  tags {
    Name = "${var.vpc_name}"
  }
}

resource "aws_internet_gateway" "ec2_igw" {
  vpc_id = "${aws_vpc.ec2_vpc.id}"

  tags {
    Name = "${var.vpc_name}-IGW"
  }
}

### Configure your subnets yo.

resource "aws_subnet" "ec2_private_subnet" {
  vpc_id                  = "${aws_vpc.ec2_vpc.id}"
  cidr_block              = "${var.private_subnets[count.index]}"
  availability_zone       = "${var.avail_zones[count.index]}"
  map_public_ip_on_launch = false
  count                   = "${length(var.private_subnets)}"

  tags {
    Name = "${var.vpc_name}-private-${element(var.avail_zones, count.index)}"
  }
}

resource "aws_subnet" "ec2_public_subnet" {
  vpc_id                  = "${aws_vpc.ec2_vpc.id}"
  cidr_block              = "${var.public_subnets[count.index]}"
  availability_zone       = "${var.avail_zones[count.index]}"
  map_public_ip_on_launch = true
  count                   = "${length(var.public_subnets)}"

  tags {
    Name = "${var.vpc_name}-public-${element(var.avail_zones, count.index)}"
  }
}

## Make a routing table?  Why not associate it too?

resource "aws_route_table" "ec2_private_route_table" {
  vpc_id = "${aws_vpc.ec2_vpc.id}"

  tags {
    Name = "${var.vpc_name}-private-routing-table"
  }
}

resource "aws_route_table_association" "ec2_private_route_table_assn" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${element(aws_subnet.ec2_private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.ec2_private_route_table.id}"
}

resource "aws_route_table" "ec2_public_route_table" {
  vpc_id = "${aws_vpc.ec2_vpc.id}"

  tags {
    Name = "${var.vpc_name}-public-routing-table"
  }
}

resource "aws_route_table_association" "ec2_public_route_table_assn" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.ec2_public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.ec2_public_route_table.id}"
}

resource "aws_route" "ec2_public_routes" {
  count                  = "${length(var.public_routes)}"
  route_table_id         = "${aws_route_table.ec2_public_route_table.id}"
  destination_cidr_block = "{values(var.public_routes)}
#  destination_cidr_block = "${lookup(var.public_routes, route)}"
}
