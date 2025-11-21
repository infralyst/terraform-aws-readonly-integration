output "infralyst_role_arn" {
  description = "The IAM Role ARN to provide to Infralyst"
  value       = module.infralyst_readonly_integration.role_arn
}
