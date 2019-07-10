#
# Optional EIP
#
resource "aws_eip" "ftp" {
  count = "${var.eip_static ? 1 : 0}"
  vpc   = true
}
