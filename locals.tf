locals {
  compartment_id = (
    var.existing_compartment != "" ? var.existing_compartment : var.existing_compartment
  )
}