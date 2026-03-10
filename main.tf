# author : Oscar Ivan Hernandez Ventura

resource "oci_mysql_mysql_db_system" "mysql_system" {
  # Basic configuration
  compartment_id      = local.compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name        = var.db_definition.name

  # Network configuration
  subnet_id  = var.subnet
  shape_name = var.db_definition.shape

  # Database configuration
  admin_username = var.username
  admin_password = var.password
  #configuration_id   = oci_mysql_mysql_configuration.custom_mysql_config

  # Storage
  data_storage_size_in_gb = var.db_definition.data_storage_size_in_gb

  backup_policy {
    is_enabled        = var.db_definition.backup_policy.is_enabled
    retention_in_days = var.db_definition.backup_policy.retention_in_days
  }

  # HA configuration
  #fault_domain      = "FAULT-DOMAIN-1"
  #availability_type = "HIGH_AVAILABILITY"  # For production

  # Maintenance
  /*
  maintenance {
    window_start_time = "SUNDAY 14:30"
  }
  */

  # Tags
  defined_tags = {
    "Oracle-Tags.CreatedBy" = "default/terraform"
  }
  freeform_tags = var.db_definition.freeform_tags
}

#https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/mysql_mysql_configuration
resource "oci_mysql_mysql_configuration" "custom_mysql_config" {
  compartment_id = var.compartment_id
  display_name   = "${var.db_definition.name}-custom-config"
  shape_name     = var.db_configuration.shape
  description    = "Custom MySQL Configuration for ${var.db_definition.name}"

  # Configuration variables
  variables {
    # Basic parameters
    autocommit                 = var.db_configuration.variables.autocommit
    binlog_expire_logs_seconds = var.db_configuration.variables.binlog_expire_logs_seconds
    binlog_row_metadata        = var.db_configuration.variables.binlog_row_metadata
    innodb_buffer_pool_size    = var.db_configuration.variables.innodb_buffer_pool_size

    # Performance tuning
    innodb_ft_result_cache_limit = var.db_configuration.variables.innodb_ft_result_cache_limit
    max_connections              = var.db_configuration.variables.max_connections
    sort_buffer_size             = var.db_configuration.variables.sort_buffer_size

    # Replication
    #server_id     = var.db_configuration.variables.server_id
    #log_bin       = var.db_configuration.variables.log_bin
    #binlog_format = var.db_configuration.variables.binlog_format

    # Security
    default_authentication_plugin = var.db_configuration.variables.default_authentication_plugin
    #local_infile                  = var.db_configuration.variables.local_infile
  }

  # Optional: Initialize from an existing configuration
  # init_variables {
  #   lower_case_table_names = "1"
  # }


  defined_tags = {
    "Oracle-Tags.CreatedBy" = "default/terraform"
  }
}