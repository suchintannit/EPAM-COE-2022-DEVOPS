output "website_bucket_domain" {
  description = "Domain name of the bucket"
  value       = module.aws_instance_module.website_bucket_domain
}
