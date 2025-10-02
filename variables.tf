variable "external_id" {
  description = "External ID provided by Infralyst (unique per workspace)"
  type        = string
}

variable "tags" {
  description = "Tags applied to created resources (optional)"
  type        = map(string)
  default     = {}
}
