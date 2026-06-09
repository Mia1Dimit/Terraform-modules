resource "aws_instance" "ec2_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = var.iam_instance_profile
  user_data                   = var.user_data
  associate_public_ip_address = var.associate_public_ip

  tags = local.merged_tags
}

resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = aws_instance.ec2_instance.availability_zone
  size              = var.ebs_volume_size
  type              = "gp3"

  tags = merge(local.merged_tags, { Name = "${var.instance_name}-ebs" })
}

resource "aws_volume_attachment" "volume_attachment" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.ebs_volume.id
  instance_id = aws_instance.ec2_instance.id
}
