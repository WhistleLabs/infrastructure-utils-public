# parameter-store

Terraform module to create and read ssm parameters.

## Usage

This example creates a new `String` parameter called `/cp/prod/app/database/master_password` with the value of `password1`.

```hcl
module "store_write" {
  source          = "./utils/parameter-store"

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
  source         = "./utils/parameter-store"
  parameter_read = ["/cp/prod/app/database/master_password"]
}
```
