#Creating VPC
resource "aws_vpc" "machi-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "machi-vpc"
  }
}
#Creating Subnets
resource "aws_subnet" "public-subnet-1" {
  vpc_id     = "${aws_vpc.machi-vpc.id}"
  cidr_block = "10.0.0.0/20"
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "machi-publicsubnet-1"
  }
}
resource "aws_subnet" "public-subnet-2" {
  vpc_id     = "${aws_vpc.machi-vpc.id}"
  cidr_block = "10.0.16.0/20"
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "machi-publicsubnet-2"
  }
}
resource "aws_subnet" "public-subnet-3" {
  vpc_id     = "${aws_vpc.machi-vpc.id}"
  cidr_block = "10.0.32.0/20"
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone = "ap-southeast-1c"

  tags = {
    Name = "machi-publicsubnet-3"
  }
}
