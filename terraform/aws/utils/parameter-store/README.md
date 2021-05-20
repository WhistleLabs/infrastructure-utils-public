# parameter-store

Terraform module to create and read ssm parameters.

## Usage

This example creates a new `String` parameter called `/cp/prod/app/database/master_password` with the value of `password1`.

```hcl
module "store_write" {
  source          = "./terraform/aws/utils/parameter-store"

  parameter_write = [
    {
      name        = "/cp/prod/app/database/master_password"
      value       = "password1"
      type        = "SecureString"
      overwrite   = "true"
      description = "Production database master password"
    }
  ]

  tags = {
    ManagedBy = "Terraform"
  }
}
```

This example reads a value from the parameter store with the name `/cp/prod/app/database/master_password`

```hcl
module "store_read" {
  source         = "./terraform/aws/utils/parameter-store"
  parameter_read = ["/cp/prod/app/database/master_password"]
}
```

This example reads a value from the parameter store with the name `/cp/prod/app/security/security_group_id` and `/cp/dev/app/security/security_group_id` and outputs `map_decoded_bn` with the parameter_read_map value as the key instead of the parameter path. Allows a short hand key name to reference parameter value instead of full parameter path.

```hcl
locals {
  ssm_state_read_enable = true
  ssm_read_parameters = {
    "/cp/prod/app/security/security_group_id" = "prod_security_group_id"
    "/cp/dev/app/security/security_group_id"  = "dev_security_group_id"
  }
  store_read          = local.ssm_state_read_enable && length(keys(try(module.store_read.map_decoded_bn, {}))) > 0 ? module.store_read.map_decoded_bn : {}
}

module "store_read" {
  source         = "./terraform/aws/utils/parameter-store"
  enabled        = local.ssm_state_read_enable
  parameter_read_map = local.ssm_read_parameters
}

resource "aws_security_group_rule" "dev_sg_http" {
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = local.store_read.dev_security_group_id
  source_security_group_id = sg-654321
  to_port                  = 8080
  type                     = "ingress"
}

resource "aws_security_group_rule" "prod_sg_http" {
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = local.store_read.prod_security_group_id
  source_security_group_id = sg-123456
  to_port                  = 8080
  type                     = "ingress"
}
```
