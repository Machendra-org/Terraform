#creating elastice-ip
resource "aws_eip" "machi-eip" {
  vpc      = "true"
  tags = {
    Name = "machi-eip"
  }
}
#creating nat-gateway
resource "aws_nat_gateway" "machi-nat" {
  allocation_id = "${aws_eip.machi-eip.id}"
  subnet_id     = "${aws_subnet.public-subnet-1.id}"

  tags = {
    Name = "machi-NAT"
  }
}
#creating internet-gateway
resource "aws_internet_gateway" "machi-igw" {
  vpc_id = "${aws_vpc.machi-vpc.id}"

  tags = {
    Name = "machi-igw"
  }
}
#creating route-tables
resource "aws_route_table" "machi-rt" {
  vpc_id = "${aws_vpc.machi-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.machi-igw.id}"
  }

  tags = {
    Name = "machi-rt"
  }
}
resource "aws_route_table_association" "machi-associate-rt" {
    subnet_id = "${aws_subnet.public-subnet-1.id}"
    route_table_id = "${aws_route_table.machi-rt.id}"
}
