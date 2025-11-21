provider "aws" {
  region = "us-east-1"
}

module "infralyst_readonly_integration" {
  source = "../../"

  # Replace with your unique External ID from Infralyst
  external_id = "your_external_id_from_infralyst"

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
