variable "content_local" {}
variable "filename_local" {}
resource "local_file" "myfilecreator"
{
content = "${var.content_local}"
filename = "${var.filename_local}"
}