output "role_arn" {
  description = "The ARN of the IAM role for Infralyst to assume"
  value       = aws_iam_role.infralyst.arn
}

output "policy_json" {
  description = "The JSON of the attached read-only policy (for audits/review)"
  value       = aws_iam_policy.readonly.policy
}
