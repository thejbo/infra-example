# AGENTS.md - Infrastructure-as-Code Repository

## Overview

OpenTofu/Terramate repository managing AWS infrastructure across accounts (master, staging, sandbox) and regions (us-east-1, us-east-2, us-west-2).

## Code Style Guidelines

**Must read:** [@CONVENTIONS.md](./CONVENTIONS.md) for detailed naming and style rules.

## Directory Structure, Account Info. and Workspace Setup

**Must read:** [@README.md](./README.md) for detailed directory structure, account info. and workspace setup.

## Build/Lint/Test Commands

```bash
# Format check (use wrapper script - respects .tool-versions)
cd units/<account>/<region>/<vpc>/<unit>
tofu.sh fmt -diff

# Validate
tofu.sh validate

# Plan
tofu.sh plan

# Apply
tofu.sh apply

# Terramate commands
terramate list
terramate run -- tofu plan
```

Install dependencies: `make all` or `make tofu` / `make terramate` / `make tofu-wrapper`


## Terramate Config (terramate.tm.hcl)

- Required version: `>= 0.17.0-rc2`
- Use `globals` for shared config across stacks
- Use `sharing_backend` for cross-stack output sharing

## State Management

S3: `{aws_account_id}-tf-state`, key: `{path}/terraform.tfstate`

## Key Conventions

- Use `local.scope` and `local.networks` for environment config
- Module root via `var.module_root`
- Follow hierarchy: data files → modules → terramate inputs
- Always review plan output before applying
