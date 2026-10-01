generate_hcl "_terraform.tofu" {
  # condition = !tm_contains(terramate.stack.tags, "no-backend")

  stack_filter {
    project_paths = [
      "units/master/**",
      "units/sandbox/**",
      "units/staging/**",
    ]
  }
  content {
    terraform {
      # required_version = "= 1.5.5"
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 6.0"
        }
        hiera5 = {
          source = "chriskuchin/hiera5"
        }
      }
    }

    # the Default provider
    provider "aws" {
      region              = global.provider_region
      profile             = global.aws_profile
      allowed_account_ids = [global.aws_account_id]

      default_tags {
        tags = {
          "Terraform-Path" = tm_replace("${terramate.stack.path.relative}", "/", ":")
        }
      }
    }
  }
}
