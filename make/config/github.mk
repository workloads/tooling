# This is a Terraform-managed file; manual changes will be overwritten.
# see https://github.com/workloads/github-organization/blob/main/templates/scripts/config_github.tftpl.mk

# GitHub Organization Slug
GITHUB_ORG = workloads

# local directories (= GitHub Repositories) to consider
GITHUB_REPOSITORIES = dns github-organization networking regional-aws-deployment regional-workspaces services-configuration services-deployment users web-assets web-redirects website workspaces

# OpenSSF Scorecard Checks to execute
SCORECARD_CHECKS = Binary-Artifacts,Branch-Protection,CI-Tests,Code-Review,Contributors,Dangerous-Workflow,Dependency-Update-Tool,License,Maintained,Pinned-Dependencies,SAST,Security-Policy,Token-Permissions,Vulnerabilities
