data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["*"]
  }
}

resource "aws_instance" "app" {
  ami           = "${data.aws_ami.app_ami.id}"
  instance_type = "t2.micro"
}