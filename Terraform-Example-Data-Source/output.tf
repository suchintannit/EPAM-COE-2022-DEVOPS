output "lb_url" {
  description = "AMi-id"
  value       = data.aws_ami.app_ami.id
}