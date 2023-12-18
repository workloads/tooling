# This is a Terraform-managed file; manual changes will be overwritten.
# see https://github.com/workloads/github-organization/blob/main/templates/scripts/config_github.tftpl.mk

# see https://docs.github.com/en/actions/learn-github-actions/contexts
GITHUB_ACTIONS_CONCLUSION = failure

# GitHub Organization Slug
GITHUB_ORG = workloads

# local directories (= GitHub Repositories) to consider
GITHUB_TERRAFORM_REPOSITORIES = $(shell gh repo list $(GITHUB_ORG) --topic=terraform --json=name --template '{{range .}}{{ .name}} {{end}}')
GITHUB_REPOSITORIES           = $(shell gh repo list $(GITHUB_ORG) --json=name --template '{{range .}}{{ .name}} {{end}}')

# OpenSSF Scorecard Checks to execute
SCORECARD_CHECKS = Binary-Artifacts,Branch-Protection,Code-Review,Dangerous-Workflow,Dependency-Update-Tool,License,Maintained,Pinned-Dependencies,SAST,Security-Policy,Token-Permissions,Vulnerabilities
