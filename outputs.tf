output "ec2_vpc_id" {
  value = "${aws_vpc.ec2_vpc.id}"
}

output "ec2_public_routing_table_id" {
  value = "${aws_route_table.ec2_public_route_table.id}"
}

output "ec2_private_routing_table_id" {
  value = "${aws_route_table.ec2_private_route_table.id}"
}

output "ec2_internet_gateway_id" {
  value = "${aws_internet_gateway.ec2_igw.id}"
}

output "ec2_public_subnet_ids" {
  value = "${join(",", aws_subnet.ec2_public_subnet.*.id)}"
}

output "ec2_private_subnet_ids" {
  value = ["${aws_subnet.ec2_private_subnet.*.id}"]
}
