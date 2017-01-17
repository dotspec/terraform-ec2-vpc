variable "vpc_cidr_block" {
  type        = "string"
  description = "CIDR of the VPC"
}

variable "vpc_name" {
  type        = "string"
  description = "The name for the VPC"
}

variable "private_subnets" {
  type = "list"
}

variable "public_subnets" {
  type = "list"
}

variable "avail_zones" {
  type = "list"
}
