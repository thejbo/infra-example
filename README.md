# Infrastructure Overview

This is an OpenTofu/Terragrunt infrastructure repository managing AWS cloud resources across multiple environments.

## Accounts

| Account    | ID           | Purpose                     |
| ---------- | ------------ | --------------------------- |
| master     | 999999999999 | AWS Org., Billing, SSO, Etc |
| production | 000000000000 | Production                  |
| staging    | 111111111111 | Staging/pre-production      |
| sandbox    | 222222222222 | Development/testing         |

## Regions

- **us-west-2** - Oregon (primary)
- **us-east-1** - Virginia
- **us-east-2** - Ohio

## IP Space Allocation

| Account    | VPC     | us-west-2    | us-east-1    | us-east-2    |
| ---------- | ------- | ------------ | ------------ | ------------ |
| production | public  | 10.24.0.0/16 | 10.0.0.0/16  | 10.48.0.0/16 |
| production | private | 10.25.0.0/16 | 10.1.0.0/16  | 10.49.0.0/16 |
| staging    | public  | 10.34.0.0/16 | 10.10.0.0/16 | 10.58.0.0/16 |
| staging    | private | 10.35.0.0/16 | 10.11.0.0/16 | 10.59.0.0/16 |
| sandbox    | public  | 10.44.0.0/16 | 10.20.0.0/16 | 10.68.0.0/16 |
| sandbox    | private | 10.45.0.0/16 | 10.21.0.0/16 | 10.69.0.0/16 |

## Architecture

```txt
units/
  [account]/
    global/          # Global resources (Route53, IAM, etc.)
    [region]/        # Region-specific resources
      shared/        # Shared infrastructure (ACM certs, DNS zones)
      public/        # Public VPCs with internet access
      private/       # Private VPCs (no internet gateway)
        [service]/   # Service units (vpc, valkey, etc.)
```

### Data Management (\_data/)

Application specific data can be placed here in a hierarchy of YAML files. This makes use of the [hiera5][] data source provider. The hierarchy is defined in /hiera.yaml

1. `%{account}/%{region}/%{vpc}/%{unit}.yaml` (most specific)
2. `%{account}/%{region}/%{vpc}.yaml`
3. `%{account}/%{region}.yaml`
4. `%{account}.yaml`
5. `common.yaml`

### \_modules/

Common modules for various resources.

### units/

"units" are where the configurations for various applications and services are managed. Each unit consists of one or more components from the \_modules section and/or direct Terraform resources.

## Local Setup

### Install dependencies

`make all` to install all dependencies

#### [opentofu][]

```sh
make tofu
make tofu-ls
```

#### [terramate][]

```sh
make terramate
```

### AWS profile

Add an appropriate profile to your ~/.aws/config: ex:

```ini
[default]
region = us-west-2
output=json
cli_pager=

[profile production]
sso_start_url = https://example.awsapps.com/start
sso_region = us-west-2
sso_account_id = 000000000000
sso_role_name = AdministratorAccess
region = us-west-2
output = json

[profile staging]
sso_start_url = https://example.awsapps.com/start
sso_region = us-west-2
sso_account_id = 111111111111
sso_role_name = AdministratorAccess
region = us-west-2
output = json

[profile sandbox]
sso_start_url = https://example.awsapps.com/start
sso_region = us-west-2
sso_account_id = 222222222222
sso_role_name = AdministratorAccess
region = us-west-2
output = json
```

[opentofu]: https://github.com/opentofu/opentofu
[terramate]: https://github.com/terramate-io/terramate/
[hiera5]: https://registry.terraform.io/providers/chriskuchin/hiera5
