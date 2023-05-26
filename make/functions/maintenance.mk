# initialize and upgrade all workspaces
define init_workspace
	$(call print_reference,$(1))

	# see https://developer.hashicorp.com/terraform/cli/commands/init
	terraform \
		-chdir="../$(1)" \
		init \
			-get=true \
			-input=false \
			-upgrade \
	;

	# see https://developer.hashicorp.com/terraform/cli/commands/providers/lock#specifying-target-platforms
	terraform \
		-chdir="../$(1)" \
		providers \
			lock \
				-platform="darwin_amd64" \
				-platform="darwin_arm64" \
				-platform="linux_amd64"  \
				-platform="linux_arm64"  \
				-platform="windows_amd64" \
				#-platform="windows_arm64" \
	;

	# see https://github.com/terraform-linters/tflint#usage
	tflint \
		--chdir="../$(1)" \
		--init \
	;
endef

# format, validate, and lint code in all workspaces
define lint_workspace
	$(call print_reference,$(1))

	# see https://developer.hashicorp.com/terraform/cli/commands/fmt
	terraform \
		-chdir="../$(1)" \
		fmt \
			-recursive \
	;

	# see https://developer.hashicorp.com/terraform/cli/commands/validate
	terraform \
		-chdir="../$(1)" \
		validate \
	;

	# see https://github.com/terraform-linters/tflint#usage
	tflint \
		-chdir="../$(1)" \
		--color \
		--config=".tflint.hcl" \
		--format=compact \
		--no-module \
	;
endef

# generate documentation for all workspaces
define render_documentation
	$(call print_reference,$(1))

	# see https://terraform-docs.io/reference/terraform-docs/
	terraform-docs \
		--config="../$(1)/.terraform-docs.yml" \
		"../$(1)" \
	;
endef

# generate OpenSSF Scorecard
define generate_scorecard
	$(call print_reference,$(1))

	# see https://github.com/ossf/scorecard#scorecard-command-line-interface
	scorecard \
      --checks="$(SCORECARD_CHECKS)" \
      --repo="github.com/$(GITHUB_ORG)/$(1)" \
      --show-details \
	;
endef

# pull latest changes for all repositories
define git_pull
	$(call print_reference,$(1))

	# see https://terraform-docs.io/reference/terraform-docs/
	git \
		-C "$(1)" \
		pull \
			--all \
			--rebase=true \
	;
endef

# delete GitHub Actions Logs for all repositories
define delete_github_actions_logs
	echo
	echo "Repository: $(STYLE_GROUP_CODE)$(1)$(STYLE_RESET)"

	# see https://cli.github.com/manual/gh_api
	gh \
		api \
			-H "Accept: application/vnd.github+json" \
			"repos/$(GITHUB_ORG)/$(1)/actions/runs" \
			--paginate \
			--jq '.workflow_runs[] | "\(.id)"' \
		| \
		xargs \
			-n "1" \
			-I "%" \
			sh -c '\
				gh \
					api \
					\"repos/$(GITHUB_ORG)/$(1)/actions/runs/%\" \
					-X DELETE \
			' \
		;
endef
