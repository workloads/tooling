# define working directory, without trailing slash
WORKING_DIR = ..

# initialize and upgrade all workspaces
# expected argument:
# $(1) - workspace to initialize and upgrade
define init_workspace
	$(call print_reference,$(1))

	# see https://developer.hashicorp.com/terraform/cli/commands/init
	terraform \
		-chdir="$(WORKING_DIR)/$(1)" \
		init \
			-get=true \
			-input=false \
			-upgrade \
	;

	# see https://developer.hashicorp.com/terraform/cli/commands/providers/lock#specifying-target-platforms
	terraform \
		-chdir="$(WORKING_DIR)/$(1)" \
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
		--chdir="$(WORKING_DIR)/$(1)" \
		--init \
	;

	echo \
	;
endef

# initialize and upgrade all workspaces
# expected argument:
# $(1) - providers to mirror
define mirror_providers
	$(call print_reference,$(1))

	# see https://developer.hashicorp.com/terraform/cli/commands/providers/lock#specifying-target-platforms
	terraform \
		-chdir="$(WORKING_DIR)/$(1)" \
		providers \
			mirror \
				"../.terraform-providers/" \
	;

	echo \
	;
endef

# format, validate, and lint code in all workspaces
# expected argument:
# $(1) - workspace to lint
define lint_workspace
	$(call print_reference,$(1))

	# see https://developer.hashicorp.com/terraform/cli/commands/fmt
	terraform \
		-chdir="$(WORKING_DIR)/$(1)" \
		fmt \
			-recursive \
	;

	# see https://developer.hashicorp.com/terraform/cli/commands/validate
	terraform \
		-chdir="$(WORKING_DIR)/$(1)" \
		validate
	;

	# see https://github.com/terraform-linters/tflint#usage
	tflint \
		--chdir="$(WORKING_DIR)/$(1)" \
		--config=".tflint.hcl" \
		--format="compact" \
		--no-module \
	;
endef

# generate documentation for all workspaces
# expected argument:
# $(1) - target to render documentation for
define render_documentation
	$(call print_reference,$(1))

	# see https://terraform-docs.io/reference/terraform-docs/
	terraform-docs \
		--config="$(WORKING_DIR)/$(1)/.terraform-docs.yml" \
		"$(WORKING_DIR)/$(1)" \
	;
endef

# generate OpenSSF Scorecard
# expected argument:
# $(1) - repository to generate scorecard for
define generate_scorecard
	$(call print_reference,$(1))

	# see https://github.com/ossf/scorecard#scorecard-command-line-interface
	# and https://developer.1password.com/docs/cli/reference/commands/run
	op \
		run \
			--account="$(OP_ACCOUNT)" \
			--env-file="$(OP_ENV_FILE)" \
			-- \
			scorecard \
				--checks="$(SCORECARD_CHECKS)" \
    		--repo="github.com/$(GITHUB_ORG)/$(1)" \
				--show-details \
			&& \
			echo "--------------------\n" \
	;
endef

# pull latest changes for all repositories
# expected argument:
# $(1) - repository to pull
define git_pull
	$(call print_reference,$(1))

	git \
		-C "$(WORKING_DIR)/$(1)" \
		pull \
			--all \
			--rebase=true \
	;
endef

# check out repository
# expected argument:
# $(1) - repository to check out
define git_checkout
	$(call print_reference,$(1))

	gh \
		repo \
			clone \
				"$(GITHUB_ORG)/$(1)" "$(1)" \
	;
endef

# delete GitHub Actions Logs for all repositories
# expected argument:
# $(1) - GitHub Repository to delete logs for
define delete_github_actions_logs
	$(call print_reference,$(1))

	# see https://cli.github.com/manual/gh_api
	# and https://developer.1password.com/docs/cli/reference/commands/run
	op \
		run \
			--account="$(OP_ACCOUNT)" \
			--env-file="$(OP_ENV_FILE)" \
			-- \
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
      					"repos/$(GITHUB_ORG)/$(1)/actions/runs/%" \
      					-X DELETE \
      			' \
	;
endef
