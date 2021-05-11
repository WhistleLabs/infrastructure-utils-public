variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}
variable "tags" {
  description = "Specifies a key-value map of user-defined tags that are attached to the parameter."
  type        = map(string)
  default     = {}
}

variable "parameter_read" {
  type        = list(string)
  description = "List of parameters to read from SSM. These must already exist otherwise an error is returned. Can be used with `parameter_write` as long as the parameters are different."
  default     = []
}

variable "parameter_write" {
  type        = list(map(string))
  description = "List of maps with the parameter values to write to SSM Parameter Store"
  default     = []
}

variable "kms_arn" {
  type        = string
  default     = ""
  description = "The ARN of a KMS key used to encrypt and decrypt SecureString values"
}

variable "split_delimiter" {
  type        = string
  default     = "~^~"
  description = "A delimiter for splitting and joining lists together for normalising the output"
}

variable "empty_string_sub" {
  type        = string
  default     = "_ssm_tfstate_empty_"
  description = "A string to use for storing an empty string for an SSM parameter."
}

variable "parameter_write_defaults" {
  type        = map(any)
  description = "Parameter write default settings"
  default = {
    description     = null
    type            = "String"
    tier            = "Standard"
    overwrite       = "true"
    allowed_pattern = ""
  }
}
