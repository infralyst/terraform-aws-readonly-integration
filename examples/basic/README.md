# Basic Example

This example demonstrates the basic usage of the Infralyst readonly integration module.

## Usage

1. Get your unique External ID from Infralyst
2. Replace `your_external_id_from_infralyst` in `main.tf` with your External ID
3. Run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

4. Copy the output `infralyst_role_arn` and paste it into Infralyst

## Inputs

| Name | Description |
|------|-------------|
| external_id | Your unique External ID from Infralyst |

## Outputs

| Name | Description |
|------|-------------|
| infralyst_role_arn | The IAM Role ARN to provide to Infralyst |
