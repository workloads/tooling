# This is a Terraform-managed file; manual changes will be overwritten.
# see https://github.com/workloads/github-organization/blob/main/templates/scripts/config_github.tftpl.mk

# see https://docs.github.com/en/actions/learn-github-actions/contexts
GITHUB_ACTIONS_CONCLUSION = failure

# GitHub Organization Slug
GITHUB_ORG = workloads

# local directories (= GitHub Repositories) to consider
GITHUB_TERRAFORM_REPOSITORIES = community dns github-organization networking regional-aws-deployment regional-azure-deployment regional-do-deployment regional-gcp-deployment regional-workspaces services-configuration services-deployment terraform-aws-regional-cidrs users web-assets web-assets-sync web-redirects website workspaces
GITHUB_REPOSITORIES           = .github assets container-images edge-case edge-case-docs minecraft-bot nomad-pack-registry packer-templates tooling

# OpenSSF Scorecard Checks to execute
SCORECARD_CHECKS = Binary-Artifacts,Branch-Protection,Code-Review,Dangerous-Workflow,Dependency-Update-Tool,License,Maintained,Pinned-Dependencies,SAST,Security-Policy,Token-Permissions,Vulnerabilities
