locals {
  parameter_write    = var.enabled ? { for e in var.parameter_write : e.name => merge(var.parameter_write_defaults, e) } : {}
  parameter_read_map = var.enabled ? (length(var.parameter_read) > 0 ? { for p in var.parameter_read : p => p } : var.parameter_read_map) : {}
}

data "aws_ssm_parameter" "read" {
  count = var.enabled ? length(local.parameter_read_map) : 0
  name  = element(keys(local.parameter_read_map), count.index)
}

resource "aws_ssm_parameter" "default" {
  for_each = local.parameter_write
  name     = each.key

  description     = each.value.description
  type            = each.value.type
  tier            = each.value.tier
  key_id          = each.value.type == "SecureString" && length(var.kms_arn) > 0 ? var.kms_arn : ""
  value           = each.value.value == "" ? var.empty_string_sub : each.value.value
  overwrite       = each.value.overwrite
  allowed_pattern = each.value.allowed_pattern
  tags            = var.tags
}
