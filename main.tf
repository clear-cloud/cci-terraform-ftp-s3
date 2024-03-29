# --------------------------
# FTP Server Auto-Scaling Group
# --------------------------
resource "aws_autoscaling_group" "ftp" {
  name                      = "${var.environment}_ftp_asg"
  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  desired_capacity          = "${var.desired_capacity}"
  launch_configuration      = "${aws_launch_configuration.ftp.name}"
  vpc_zone_identifier       = ["${var.vpc_zone_identifier}"]
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${var.health_check_type}"

  tag {
    key                 = "Name"
    value               = "${var.hostname}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "environment"
    value               = "${var.environment}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "orchestration"
    value               = "${var.orchestration}"
    propagate_at_launch = "true"
  }
}
