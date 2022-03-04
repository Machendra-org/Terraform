#Creating EC2-instance
resource "aws_instance" "instance" {
    ami  = "ami-055d15d9cfddf7bd3"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.machi-sgp.id}"]
    iam_instance_profile = aws_iam_instance_profile.machi_profile.name
    subnet_id = "${aws_subnet.public-subnet-1.id}"
    key_name = "vpc"

    tags = {
        Name = "machi-ec2"
    }
}
