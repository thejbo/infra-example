generate_hcl "_defaults.tofu" {
  # condition = !tm_contains(terramate.stack.tags, "no-backend")

  stack_filter {
    project_paths = [
      "units/master/**",
      "units/sandbox/**",
      "units/staging/**",
    ]
  }
  content {
    variable "module_root" {
      default = "${terramate.stack.path.to_root}/_modules/"
    }

    data "hiera5_json" "account" {
      key = "account"
    }

    data "hiera5_json" "scope" {
      key = "scope"
    }

    data "hiera5_json" "regions" {
      key = "regions"
    }

    data "hiera5_json" "networks" {
      key = "networks"
    }

    locals {
      account          = jsondecode(data.hiera5_json.account.value)
      networks         = jsondecode(data.hiera5_json.networks.value)
      scope            = jsondecode(data.hiera5_json.scope.value)
      regions          = jsondecode(data.hiera5_json.regions.value)
      aws_account_name = "${global.aws_account_name}"
      aws_account_id   = "${global.aws_account_id}"
      aws_region       = "${global.aws_region}"
      vpc_name         = "${global.vpc_name}"
    }
  }
}
