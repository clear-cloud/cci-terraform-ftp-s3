# ---------------------------------------
# Launch Config
# ---------------------------------------
resource "aws_launch_configuration" "ftp" {
  depends_on           = ["aws_eip.ftp"]
  name_prefix          = "terraform-ftp-lc-"
  image_id             = "${var.image_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.ftp_instance_profile.name}"
  security_groups      = ["${var.security_groups}"]
  user_data            = "${data.template_file.user_data.rendered}"

  # Setup root block device
  root_block_device {
    volume_size = "${var.volume_size}"
    volume_type = "${var.volume_type}"
  }

  # Create before destroy
  lifecycle {
    create_before_destroy = true
    ignore_changes = ["user_data"]
  }
}

# ---------------------------------------
# Render Bastion bootstrap file
# ---------------------------------------
data "template_file" "user_data" {
  depends_on           = ["aws_s3_bucket.ftp"]
  template = "${file("${path.module}/userdata.sh")}"

  vars = {
    hostname                    = "${var.hostname}"
    dns_domain_name             = "${var.dns_domain_name}"
    hosted_zone_id              = "${var.hosted_zone_id}"
    supplementary_user_data_pre = "${var.supplementary_user_data_pre}"
    supplementary_user_data     = "${var.supplementary_user_data}"
    region                      = "${var.region}"
    s3_bucket                   = "${aws_s3_bucket.ftp.id}"
  }
}
