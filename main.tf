terraform {
  required_version = ">= 1.4.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

locals {
  infralyst_assumer_role = "arn:aws:iam::560186488871:role/infralyst-assumer"
}

# Cross-account role Infralyst will assume (with External ID)
resource "aws_iam_role" "infralyst" {
  name        = "infralyst-readonly"
  description = "Read-only cross-account role assumed by Infralyst (STS + External ID)"
  path        = "/"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Action    = "sts:AssumeRole",
      Principal = { AWS = local.infralyst_assumer_role },
      Condition = { StringEquals = { "sts:ExternalId" = var.external_id } }
    }]
  })

  tags = var.tags
}

# Minimal read-only access for analysis (EC2/ASG + CloudWatch)
data "aws_iam_policy_document" "readonly" {
  statement {
    sid = "EC2Reads"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:DescribeVolumes"
    ]
    resources = ["*"]
  }

  statement {
    sid       = "ASGReads"
    actions   = ["autoscaling:DescribeAutoScalingGroups"]
    resources = ["*"]
  }

  statement {
    sid       = "CloudWatchMetrics"
    actions   = ["cloudwatch:GetMetricData"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "readonly" {
  name        = "infralyst-readonly-policy"
  description = "Least-privilege read-only policy for Infralyst analysis"
  policy      = data.aws_iam_policy_document.readonly.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.infralyst.name
  policy_arn = aws_iam_policy.readonly.arn
}
