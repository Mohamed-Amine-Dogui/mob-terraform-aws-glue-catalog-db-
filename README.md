# Terraform Module: AWS Lake Formation Table Filter

This Terraform module facilitates the automated deployment and management of AWS Lake Formation table filters and permissions. It's designed to handle both table and column-level granularity, providing flexibility for various data access scenarios. The module includes conditional logic to ensure resources are created only when necessary, and integrates an external module for consistent resource labeling.

### Features
- **Automated Lake Formation Permissions Management**: Configures AWS Lake Formation permissions for specified tables, managing them throughout their lifecycle.
- **Conditional Resource Creation**: Allows enabling or disabling the creation of resources using the `enable` variable.
- **Column-Level Granularity**: Support for managing access at a column level for finer-grained control.
- **Tagging**: Integrates with a labeling module to apply consistent tags to resources.
- **IAM Role Handling**: Automatically assigns permissions to a list of specified IAM role ARNs for consuming the filtered data.

### Module Usage

```hcl
module "lakeformation_table_filter" {
  source = "git::ssh://git@github.mpi-internal.com/mohamed-aminedogui-ext/terraform-aws-lakeformation-table-filter-deployment.git?ref=tags/0.0.1"

  enable                 = true
  filter_name            = "example-filter"
  database_name          = "example-database"
  table_name             = "example-table"
  list_consumer_iam_role_arn = [
    "arn:aws:iam::123456789012:role/consumer-role1",
    "arn:aws:iam::123456789012:role/consumer-role2"
  ]

  stage                  = "dev"
  project                = var.project
  project_id             = var.project_id
  tags                   = var.tags
  git_repository         = var.git_repository
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lake_formation_filter_labels"></a> [lake\_formation\_filter\_labels](#module\_lake\_formation\_filter\_labels) | git::ssh://git@github.mpi-internal.com/datastrategy-mobile-de/terraform-aws-label-deployment.git?ref=tags/0.0.1 |  |

## Resources

| Name | Type |
|------|------|
| [aws_lakeformation_permissions.filter_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_permissions) | resource |
| [aws_lakeformation_data_lake_settings.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_data_lake_settings) | resource |
| [data.aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable"></a> [enable](#input\_enable) | Whether to create the stack in this module or not. | `bool` | `true` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage of the Stack (dev/pre/prd) | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | ID used for billing | `string` | `"Not Set"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Instance specific Tags | `map(string)` | `{}` | no |
| <a name="input_git_repository"></a> [git\_repository](#input\_git\_repository) | Repository where the infrastructure was deployed from. | `string` | n/a | yes |
| <a name="input_filter_name"></a> [filter\_name](#input\_filter\_name) | Name of the filter | `string` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name of the database | `string` | n/a | yes |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | Name of the table | `string` | n/a | yes |
| <a name="input_list_consumer_iam_role_arn"></a> [list\_consumer\_iam\_role\_arn](#input\_list\_consumer\_iam\_role\_arn) | List of IAM role ARNs of the consumers | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_filter_name"></a> [filter\_name](#output\_filter\_name) | The name of the filter |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | The name of the database |
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | The name of the table |
| <a name="output_filter_permissions"></a> [filter\_permissions](#output\_filter\_permissions) | The Lake Formation filter permissions resource IDs |

<!-- END_TF_DOCS -->
