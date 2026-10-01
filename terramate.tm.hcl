terramate {
  required_version = ">= 0.17.0-rc2"
  config {

    # Optionally disable safe guards
    # Learn more: https://terramate.io/docs/cli/orchestration/safeguards
    disable_safeguards = [
      "git-untracked",
      "git-uncommitted",
      "git-out-of-sync",
      "outdated-code",
    ]

    run {
      env {
        TF_PLUGIN_CACHE_DIR = "${terramate.root.path.fs.absolute}/.tf_plugin_cache_dir"
      }
    }

    # Enable Terramate Scripts
    experiments = [
      "scripts",
      "outputs-sharing",
      "tmgen",
    ]

    telemetry {
      enabled = false
    }
  }
}

globals "generators" {
  version = "v1"
}

globals "terraform" "backend" {
  bucket = "${global.aws_account_id}-tf-state"
  region = "us-west-2"
}

globals {
  vpc_name        = "none"
  aws_region      = "global"
  provider_region = global.aws_region == "global" ? "us-west-2" : global.aws_region
}

import {
  source = "./templates/terramate/*.tm.hcl"
}

sharing_backend "default" {
  type     = terraform
  filename = "_sharing.tofu"
  command  = ["tofu", "output", "-json"]
}
