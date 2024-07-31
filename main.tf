locals {
  project_id = var.project_id == "" ? var.project : var.project_id
}

data "aws_caller_identity" "current" {}

module "glue_catalog_labels" {
  source          = "git::ssh://git@github.mpi-internal.com/datastrategy-mobile-de/terraform-aws-label-deployment.git?ref=tags/0.0.1"
  stage           = var.stage
  project         = var.project
  project_id      = local.project_id
  name            = var.glue_database_name
  resource_group  = ""
  resources       = ["db"]
  additional_tags = var.tags
  max_length      = 64
  git_repository  = var.git_repository
}

# main.tf

resource "aws_glue_catalog_database" "tf_delta_db" {
  count = var.enable ? 1 : 0
  name       = module.glue_catalog_labels.resource["db"]["id"]
  catalog_id = data.aws_caller_identity.current.account_id

  create_table_default_permission {
    permissions = ["ALL"]

    principal {
      data_lake_principal_identifier = "IAM_ALLOWED_PRINCIPALS"
    }
  }
}

resource "aws_lakeformation_permissions" "grant_permissions" {
  count = var.enable ? 1 : 0

  principal = var.iam_role_arn

  permissions = ["CREATE_TABLE", "DESCRIBE"]
  permissions_with_grant_option = ["CREATE_TABLE", "DESCRIBE"]

  database {
    catalog_id = data.aws_caller_identity.current.account_id
    name = aws_glue_catalog_database.tf_delta_db[count.index].name
  }
}

output "glue_database_name" {
  description = "The name of the Glue Catalog Database."
  value       = element(aws_glue_catalog_database.tf_delta_db.*.name, 0)
}

output "glue_database_arn" {
  description = "The ARN of the Glue Catalog Database."
  value       = element(aws_glue_catalog_database.tf_delta_db.*.arn, 0)
}

output "glue_database_catalog_id" {
  description = "The catalog ID of the Glue Catalog Database."
  value       = element(aws_glue_catalog_database.tf_delta_db.*.catalog_id, 0)
}

output "lakeformation_permissions_principal" {
  description = "The IAM role to which Lake Formation permissions are granted."
  value       = element(aws_lakeformation_permissions.grant_permissions.*.principal, 0)
}

output "lakeformation_permissions" {
  description = "The permissions granted to the IAM role."
  value       = element(aws_lakeformation_permissions.grant_permissions.*.permissions, 0)
}

output "lakeformation_permissions_with_grant_option" {
  description = "The permissions with grant option granted to the IAM role."
  value       = element(aws_lakeformation_permissions.grant_permissions.*.permissions_with_grant_option, 0)
}

output "project_id" {
  description = "The project ID used for billing."
  value       = local.project_id
}


# variables.tf

variable "enable" {
  description = "Whether to create the stack in this module or not."
  type        = bool
  default     = true
}

variable "stage" {
  description = "Stage of the Stack (dev/pre/prd)"
}

variable "project" {}

variable "project_id" {
  type        = string
  default     = "Not Set"
  description = "ID used for billing"
}

variable "tags" {
  description = "Instance specific Tags"
  type        = map(string)
  default     = {}
}

variable "git_repository" {
  type        = string
  description = "Repository where the infrastructure was deployed from."
}

variable "glue_database_name" {
  description = "The name of the Glue database"
  type        = string
}

variable "iam_role_arn" {
  description = "The iam role of the Glue Crawler"
  type        = string
}

