# Code Conventions

## General Principles
- Use modules - smaller blast radius, faster plan/apply, less need for `-target`
- Don't hardcode values - use variables or data sources
- Replace repetitive resources with `for_each` or locals
- Use OpenTofu enabled Meta-Argument for conditional resources (see: https://opentofu.org/docs/language/meta-arguments/enabled/)
  ```hcl
  lifecycle {
    enabled = true
  }
  ```
- Extract repeated expressions into locals
- Parameterize hardcoded values appropriately

## Naming / Style
- Use kebab-case for file names
- One resource type per file when practical

- Variables
  - Use the plural form in a variable name when type is `list(...)` or `map(...)`.
  - Order keys in a variable block like this: `description` , `type`, `default`, `validation`.
  - Always include description on all variables even if you think it is obvious (you will need it in the future).
  - Prefer using simple types (`number`, `string`, `list(...)`, `map(...)`, `any`) over specific type like `object()` unless you need to have strict constraints on each key.
  - Define in `variables.tf`

- Outputs
  - Declare all outputs that might be useful to module consumers.
  - Use plural names for lists/maps: `subnets`, `tags`
  - Always include `description` for all outputs even if you think it is obvious.
  - Define in `outputs.tf`

- Resources
  - Use snake-case (`_`) for resource names, data source names, variable names, outputs, etc.
  - Use kebab-case (`-`) inside argument values and in places where value will be exposed to a human (eg, inside DNS name or tag values).
  - `resource "aws_vpc" "this"` - use "this" for single resources
  - `resource "aws_instance" "example"` - descriptive name for multiple
  - Prefer to use lowercase letters and numbers.
  - Argument Order
    1. `for_each` if necessary, followed by a blank line.
    2. Resource arguments.
    3. `Tags` block (prefixed by a blank line)
    4. Terraform "meta-argument blocks" (i.e. `lifecycle`, `depends_on`, etc.) (prefixed by a blank line)

    Example:

    ```hcl
    resource "aws_instance" "example" {

      ami           = "abc123"
      instance_type = "t2.micro"

      network_interface {
        # ...
      }

      tags {
        "Managed-By" = "terraform"
      }

      lifecycle { # meta-argument block last
        create_before_destroy = true
      }
    }
    ```

- Data Sources
  - Put data sources next to the resources that reference them. For example, if you are fetching an image to be used in launching an instance, place it alongside the instance instead of collecting data resources in their own file.
  - If the number of data sources becomes large, consider moving them to a dedicated `data.tf` file.

## Security Implementation

- Remove hardcoded credentials or overly permissive IAM policies
- All secrets through Parameter Store
- Apply the principle of least privilege in resource configurations
- Add proper input validation for security-sensitive variables

## Documentation

- Create or update README files for modules
- Add usage examples to demonstrate module implementation
- Document required and optional variables with their descriptions and defaults
- Include dependency information and version requirements
