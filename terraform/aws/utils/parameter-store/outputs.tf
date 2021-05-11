# Splitting and joining, and then compacting a list to get a normalised list
locals {
  name_list = compact(
    concat(
      split(
        var.split_delimiter,
        join(var.split_delimiter, [for p in aws_ssm_parameter.default : p.name])
      ),
      split(
        var.split_delimiter,
        join(var.split_delimiter, data.aws_ssm_parameter.read.*.name)
      )
    )
  )

  value_list = compact(
    concat(
      split(
        var.split_delimiter,
        join(var.split_delimiter, [for p in aws_ssm_parameter.default : p.value])
      ),
      split(
        var.split_delimiter,
        join(var.split_delimiter, data.aws_ssm_parameter.read.*.value)
      )
    )
  )

  arn_list = compact(
    concat(
      split(
        var.split_delimiter,
        join(var.split_delimiter, [for p in aws_ssm_parameter.default : p.arn])
      ),
      split(
        var.split_delimiter,
        join(var.split_delimiter, data.aws_ssm_parameter.read.*.arn)
      )
    )
  )
  basename_decoded_values = { for k, v in zipmap(local.name_list, local.value_list) : (try(basename(k), k)) => (try(jsondecode(v), tostring(v == var.empty_string_sub ? "" : v))) }
}

output "names" {
  value       = local.name_list
  description = "A list of all of the parameter names"
}

output "values" {
  description = "A list of all of the parameter values"
  value       = local.value_list
}

output "map_decoded_bn" {
  description = "A map of the names and values created"
  value       = local.basename_decoded_values
}

output "map" {
  description = "A map of the names and values created"
  value       = zipmap(local.name_list, local.value_list)
}
output "arn_map" {
  description = "A map of the names and ARNs created"
  value       = zipmap(local.name_list, local.arn_list)
}