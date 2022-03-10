resource "aws_ebs_volume" "machi-vol" {
  availability_zone = "ap-southeast-1b"
  size              = 5

  tags = {
    Name = "machi-volume"
  }
}
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.machi-vol.id}"
  instance_id = "${aws_instance.instance.id}"
  force_detach = true
}
