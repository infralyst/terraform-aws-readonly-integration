# Terraform AWS Read-Only Integration for Infralyst

Creates a read-only cross-account IAM role for Infralyst with External ID; least-privilege policy for EC2, ASG, and CloudWatch metrics.

## What This Module Does

This module provisions a secure, read-only IAM role in your AWS account that Infralyst can assume to analyze your infrastructure. It uses:
- **STS AssumeRole** with an **External ID** for secure cross-account access
- **Least-privilege IAM policy** limited to EC2 instances, Auto Scaling Groups, and CloudWatch metrics
- **No long-lived credentials** — access can be revoked instantly by removing the module

## How It Works

1. Creates an IAM role in your AWS account
2. Configures a trust policy allowing Infralyst's AWS account to assume the role
3. Requires an External ID (provided by Infralyst) to prevent the confused deputy problem
4. Attaches a minimal read-only policy with only the permissions needed for infrastructure analysis
5. Infralyst assumes the role via STS when analyzing your infrastructure

## Quickstart

```hcl
module "infralyst_readonly_integration" {
  source  = "infralyst/readonly-integration/aws"
  version = "~> 0.1"

  external_id = "<infralyst_YOUR_WORKSPACE_EXTERNAL_ID>"

  # Optional
  # tags = { Owner = "Platform" }
}

output "infralyst_role_arn" {
  value       = module.infralyst_readonly_integration.role_arn
  description = "Paste this Role ARN into Infralyst"
}
```

Run:
```bash
terraform init
terraform apply
```

Copy the `infralyst_role_arn` output and paste it into Infralyst to complete the integration.

## Inputs

| Name          | Description                                                      | Type          | Default | Required |
| ------------- | ---------------------------------------------------------------- | ------------- | ------- | -------- |
| `external_id` | External ID provided by Infralyst (unique per workspace/account) | `string`      | -       | yes      |
| `tags`        | Tags applied to created resources                                | `map(string)` | `{}`    | no       |

**Note:** The IAM role name is fixed as `infralyst-readonly` and cannot be changed. This is required by Infralyst's assume-role policy.

## Outputs

| Name          | Description                                                   |
| ------------- | ------------------------------------------------------------- |
| `role_arn`    | The ARN of the IAM role for Infralyst to assume               |
| `policy_json` | The JSON of the attached read-only policy (for audits/review) |

## Permissions Included

The module grants the following read-only permissions:

### EC2
- `ec2:DescribeInstances` — List and describe EC2 instances
- `ec2:DescribeInstanceTypes` — Get details about instance types
- `ec2:DescribeLaunchTemplates` — List and describe launch templates
- `ec2:DescribeLaunchTemplateVersions` — Get launch template version details
- `ec2:DescribeVolumes` — List and describe EBS volumes
- `ec2:DescribeTags` — List and describe tags on EC2 resources

### Auto Scaling
- `autoscaling:DescribeAutoScalingGroups` — List and describe Auto Scaling Groups
- `autoscaling:DescribeAutoScalingInstances` — List and describe Auto Scaling instances

### CloudWatch
- `cloudwatch:GetMetricData` — Retrieve metric data for analysis
- `cloudwatch:GetMetricStatistics` — Retrieve metric statistics for analysis

All permissions are scoped to `"Resource": "*"` as these are read-only describe/list operations that don't support resource-level permissions.

## Security Notes

- **External ID required**: The role can only be assumed by Infralyst using the External ID you provide, preventing unauthorized access
- **No access keys**: Uses temporary STS credentials only — no long-lived API keys are created or stored
- **Read-only**: All permissions are strictly read-only describe/list operations
- **Instant revocation**: Remove the module and run `terraform apply` to immediately revoke all access
- **Audit trail**: Review the exact policy JSON via the `policy_json` output or AWS Console

## Removal

To revoke Infralyst's access:

1. Remove the module block from your Terraform configuration
2. Run `terraform apply`

Terraform will destroy the IAM role and policy, immediately terminating Infralyst's ability to access your account.

## Versioning

This module follows [Semantic Versioning](https://semver.org/):
- **Patch releases** (0.1.x): Bug fixes, documentation updates
- **Minor releases** (0.x.0): New read-only permissions added, backward-compatible changes
- **Major releases** (x.0.0): Breaking changes

**Recommendation**: Pin to `~> 0.1` to automatically receive new read-only permissions and bug fixes while avoiding breaking changes.

## License

MIT — See [LICENSE](LICENSE) for details.
