generate_hcl "_hiera.tofu" {
  # condition = !tm_contains(terramate.stack.tags, "no-backend")

  stack_filter {
    project_paths = [
      "units/master/**",
      "units/sandbox/**",
      "units/staging/**",
    ]
  }

  content {
    provider "hiera5" {
      config = "${terramate.stack.path.to_root}/hiera.yaml"
      merge  = "deep"
      scope = {
        account = "${global.aws_account_name}"
        region  = "${global.aws_region}"
        vpc     = "${global.vpc_name}"
        unit    = "${terramate.stack.path.basename}"
      }
    }
  }
}
