# Terraform AWS Secret Replicas

A Terraform module that gets a mapping of all replica secrets for a given source AWS Secrets Manager secret. This is useful when you want to reference the ARNs, KMS Key IDs, or other values of a secret's replica in a different region, since the [aws_secretsmanager_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) resource doesn't return replica ARNs in the `replica` attribute.

## Usage

```
resource "aws_secretsmanager_secret" "example" {
  provider = aws.ca-central-1

  name     = "example"
  description = "This is a demo of the Invicton-Labs/secret-replicas/aws module!"

  replica {
    region = "us-west-2"
  }

  replica {
    region = "eu-north-1"
  }
}

module "secret_replicas" {
    source = "Invicton-Labs/secret-replicas/aws"

    // Pass the entire resource into this module
    secret = aws_secretsmanager_secret.example

    // Whether to include the original secret (the source that is replicated)
    // in the output. Defaults to `true`, but we show it here for clarity.
    include_original = true
}

output "secret_replicas" {
    value = module.secret_replicas.secrets_by_region
}
```

Output:
```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

secret_replicas = tomap({
  "ca-central-1" = {
    "arn" = "arn:aws:secretsmanager:ca-central-1:170970691995:secret:example-gfJ8fE"
    "description" = "This is a demo of the Invicton-Labs/secret-replicas/aws module!"
    "is_replica" = false
    "kms_key_id" = "alias/aws/secretsmanager"
    "name" = "example"
    "region" = "ca-central-1"
    "status" = tostring(null)
    "status_message" = tostring(null)
    "tags" = tomap(null) /* of string */
    "tags_all" = tomap({})
  }
  "eu-north-1" = {
    "arn" = "arn:aws:secretsmanager:eu-north-1:170970691995:secret:example-gfJ8fE"
    "description" = "This is a demo of the Invicton-Labs/secret-replicas/aws module!"
    "is_replica" = true
    "kms_key_id" = "alias/aws/secretsmanager"
    "name" = "example"
    "region" = "eu-north-1"
    "status" = "InProgress"
    "status_message" = ""
    "tags" = tomap(null) /* of string */
    "tags_all" = tomap({})
  }
  "us-west-2" = {
    "arn" = "arn:aws:secretsmanager:us-west-2:170970691995:secret:example-gfJ8fE"
    "description" = "This is a demo of the Invicton-Labs/secret-replicas/aws module!"
    "is_replica" = true
    "kms_key_id" = "alias/aws/secretsmanager"
    "name" = "example"
    "region" = "us-west-2"
    "status" = "InProgress"
    "status_message" = ""
    "tags" = tomap(null) /* of string */
    "tags_all" = tomap({})
  }
})
```
