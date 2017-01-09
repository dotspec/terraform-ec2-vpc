output "ec2_vpc_id" {
  value = "${aws_vpc.ec2_vpc.id}"
}

output "ec2_public_routing_table_id" {
  value = "${aws_route_table.ec2_public_route_table.id}"
}

output "ec2_private_routing_table_id" {
  value = "${aws_route_table.ec2_private_route_table.id}"
}