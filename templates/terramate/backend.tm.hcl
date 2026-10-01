generate_hcl "_backend.tofu" {
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
      backend "s3" {
        region  = global.terraform.backend.region
        bucket  = global.terraform.backend.bucket
        profile = global.aws_profile
        //key          = tm_try(global.terraform.backend.key, "terraform/stacks/by-id/${terramate.stack.id}/terraform.tfstate")
        key          = tm_try(global.terraform.backend.key, "${tm_replace(terramate.stack.path.relative, "units/", "")}/terraform.tfstate")
        encrypt      = true
        use_lockfile = true
      }
    }
  }
}
