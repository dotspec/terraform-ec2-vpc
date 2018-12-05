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
  availability_zone       = "${element(var.avail_zones, count.index)}"
  map_public_ip_on_launch = false
  count                   = "${length(var.private_subnets)}"

  tags {
    Name    = "${var.vpc_name}-private-${element(var.avail_zones, count.index)}"
    Routing = "Private"
  }
}

resource "aws_subnet" "ec2_public_subnet" {
  vpc_id                  = "${aws_vpc.ec2_vpc.id}"
  cidr_block              = "${var.public_subnets[count.index]}"
  availability_zone       = "${element(var.avail_zones, count.index)}"
  map_public_ip_on_launch = true
  count                   = "${length(var.public_subnets)}"

  tags {
    Name = "${var.vpc_name}-public-${element(var.avail_zones, count.index)}"
  }
}

## Make a routing table? How about two?  Why not associate it?

resource "aws_route_table" "ec2_private_route_table" {
  count  = "${length(var.private_subnets)}"
  vpc_id = "${aws_vpc.ec2_vpc.id}"

  tags {
    Name = "${var.vpc_name}-${element(var.private_subnets, count.index)}-priv-RT"
  }
}

resource "aws_route_table_association" "ec2_private_route_table_assn" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${element(aws_subnet.ec2_private_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.ec2_private_route_table.*.id, count.index)}"
}

resource "aws_route_table" "ec2_public_route_table" {
  count  = "${length(var.public_subnets)}"
  vpc_id = "${aws_vpc.ec2_vpc.id}"

  tags {
    Name = "${var.vpc_name}-${element(var.public_subnets, count.index)}-pub-RT"
  }
}

resource "aws_route_table_association" "ec2_public_route_table_assn" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.ec2_public_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.ec2_public_route_table.*.id, count.index)}"
}
