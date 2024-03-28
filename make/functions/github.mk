# GitHub-specific Make functions

BINARY_GH  ?= gh
BINARY_GIT ?= git

# for additional configuration, see "../configs/github.mk"


# pull latest changes for all repositories
#
#		expected arguments:
#			$(1) - repository to pull
define git_pull
	$(call print_reference,$(1))

	$(BINARY_GIT) \
		-C "$(WORKING_DIR)/$(1)" \
		pull \
			--all \
			--rebase=true \
	;
endef

# delete GitHub Actions Logs for all repositories
#
#		expected arguments:
#			$(1) - GitHub Repository to delete logs for
define github_delete_actions_logs
	$(call print_reference,$(1))

	# see https://cli.github.com/manual/gh_api
	# and https://developer.1password.com/docs/cli/reference/commands/run
	$(BINARY_OP) \
		run \
			--account="$(ONEPASSWORD_ACCOUNT)" \
			--env-file="$(ONEPASSWORD_SECRETS_FILE)" \
			-- \
			$(BINARY_GH) \
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
							$(BINARY_GH) \
								api \
								"repos/$(GITHUB_ORG)/$(1)/actions/runs/%" \
								-X DELETE \
						' \
	;
endef

# check out repository
#
#		expected arguments:
#		$(1) - repository to check out
define git_checkout
	$(call print_reference,$(1))

	$(BINARY_GH) \
		repo \
			clone \
				"$(GITHUB_ORG)/$(1)" "$(1)" \
	;
endef

# get GitHub API rate limit status
#
#		expected arguments:
#			n/a
define github_get_api_rate_limit_status
	# see https://cli.github.com/manual/gh_api
	# and https://developer.1password.com/docs/cli/reference/commands/run
	$(BINARY_OP) \
		run \
			--account="$(ONEPASSWORD_ACCOUNT)" \
			--env-file="$(ONEPASSWORD_SECRETS_FILE)" \
			-- \
			$(BINARY_GH) \
				api \
					-H "Accept: application/vnd.github+json" \
					"/rate_limit" \
			| \
			$(BINARY_JQ) \
					--raw-output \
					'.rate.remaining, .rate.limit' \
			| \
			awk ' \
				{ \
				if (NR == 1) { \
					LIMIT = ($$0 > 0) ? "$(STYLE_FG_GREEN)" : "$(STYLE_FG_RED)";\
					printf "remaining: %s%d$(STYLE_RESET) / ", LIMIT, $$0 \
				} \
				\
				else { print $$0 } \
				} \
			'
	echo
endef
