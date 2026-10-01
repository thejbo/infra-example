#!/bin/bash
AWS_LOGIN_PROFILE=cog-master

get_creds() {
  creds=$(aws configure export-credentials --profile ${AWS_LOGIN_PROFILE})
  if [[ $? != 0 ]]; then
    aws sso login --profile ${AWS_LOGIN_PROFILE}
  fi
}

run_cmd() { # command
  echo "$@"
  eval $@
}

get_creds

run_cmd terramate generate
run_cmd terramate fmt
run_cmd terramate run tofu fmt
run_cmd terramate run --enable-sharing  tofu $@

