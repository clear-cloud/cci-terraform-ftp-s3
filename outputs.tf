
#
# Define outputs
#

output "asg_id" {
  description = "Auto Scaling Group id"
  value       = "${aws_autoscaling_group.ftp.id}"
}

output "public_ip" {
  description = "EIP public IP"
  value = "${aws_eip.ftp.public_ip}"
}
