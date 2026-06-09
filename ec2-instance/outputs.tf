output "instance_id" { value = aws_instance.ec2_instance.id }
output "instance_arn" { value = aws_instance.ec2_instance.arn }
output "public_ip" { value = aws_instance.ec2_instance.public_ip }
output "ebs_volume_id" { value = aws_ebs_volume.ebs_volume.id }
