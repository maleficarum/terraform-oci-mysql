variable "compartment_id" {
  type        = string
  default     = ""
  description = "The compartment OCID to be created to hold the mysql resources"
}

variable "existing_compartment" {
  type        = string
  default     = ""
  description = "The compartment OCID that already exists and will hodl the mysql resources; it this is set, compartment_id should be blank"
}

variable "db_definition" {
  type = object({
    name                    = string,
    shape                   = string,
    data_storage_size_in_gb = number,
    backup_policy = object({
      is_enabled        = bool,
      retention_in_days = number
    }),
    freeform_tags = optional(map(string), {})
  })
  description = "The DB definition"
}

variable "db_configuration" {
  description = "The DB specific configuration"
  type = object({
    shape = string,

    variables = object({
      autocommit                   = bool,
      binlog_expire_logs_seconds   = number,
      binlog_row_metadata          = string, # FULL, MINIMAL
      innodb_buffer_pool_size      = number,
      innodb_ft_result_cache_limit = number,
      max_connections              = number,
      sort_buffer_size             = number,
      #server_id                     = string,
      #log_bin                       = string,
      #binlog_format                 = string,
      default_authentication_plugin = string, # mysql_native_password, sha256_password, caching_sha2_password
      #local_infile                  = string
    })
  })
}

variable "subnet" {
  type        = string
  description = "The subnet to deploy the DB system"
}

# variable "environment" {
#   type        = string
#   description = "The environment"
# }

#TODO: Agregar esto a un vault
variable "username" {
  type        = string
  description = "The username"
  sensitive   = true
}

#TODO: Agregar esto a un vault
variable "password" {
  type        = string
  description = "The password"
  sensitive   = true
}