# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-01-16

### Added

- ECS permissions: ListClusters, ListServices, DescribeServices, DescribeTaskDefinition

## [1.1.0] - 2025-12-12

### Removed

- EKS permissions (eks:DescribeNodegroup) - not currently used

## [1.0.0] - 2025-11-21

### Added

- Initial release of the Infralyst readonly integration module
- Cross-account IAM role with External ID for secure access
- Read-only permissions for:
  - EC2: DescribeInstances, DescribeVolumes, DescribeSecurityGroups, DescribeVpcs, DescribeSubnets, DescribeTags
  - Auto Scaling: DescribeAutoScalingGroups, DescribeAutoScalingInstances, DescribeScalingActivities
  - EKS: DescribeClusters, ListClusters, DescribeNodegroup
  - CloudWatch: GetMetricData, GetMetricStatistics
- Configurable tags for all created resources
- Outputs for role ARN and policy JSON (for auditing)
