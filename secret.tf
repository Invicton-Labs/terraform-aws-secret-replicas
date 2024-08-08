data "aws_arn" "secret" {
  arn = var.secret.arn
}

locals {
  common_attributes = {
    id          = var.secret.id
    description = var.secret.description
    tags_all    = var.secret.tags_all
    tags        = var.secret.tags
    name        = var.secret.name
    name_prefix = var.secret.name_prefix
  }
  original_secret = {
    (data.aws_arn.secret.region) = merge(local.common_attributes, {
      arn                = var.secret.arn
      region             = data.aws_arn.secret.region
      kms_key_id         = var.secret.kms_key_id == "" || var.secret.kms_key_id == null ? "alias/aws/secretsmanager" : var.secret.kms_key_id
      status             = null
      status_message     = null
      last_accessed_date = null
      is_replica         = false
    })
  }
  replica_secrets = {
    for replica in var.secret.replica :
    (replica.region) => merge(local.common_attributes, {
      arn                = "arn:${data.aws_arn.secret.partition}:${data.aws_arn.secret.service}:${replica.region}:${data.aws_arn.secret.account}:${data.aws_arn.secret.resource}"
      region             = replica.region
      kms_key_id         = replica.kms_key_id == "" || replica.kms_key_id == null ? "alias/aws/secretsmanager" : replica.kms_key_id
      status             = replica.status
      status_message     = replica.status_message
      last_accessed_date = replica.last_accessed_date
      is_replica         = true
    })
  }
}
