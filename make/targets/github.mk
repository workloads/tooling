.SILENT .PHONY: pull
pull: # pull latest changes for all repositories [Usage: `make pull`]
	$(foreach REPOSITORY,$(GITHUB_REPOSITORIES),$(call git_pull,$(strip $(REPOSITORY))))

.SILENT .PHONY: checkout
checkout: # check out all (public and private) repositories [Usage: `make checkout`]
	$(foreach REPOSITORY,$(GITHUB_REPOSITORIES),$(call git_checkout,$(strip $(REPOSITORY))))

.SILENT .PHONY: delete-gha-logs
delete-gha-logs: # delete GitHub Actions Logs for all repositories [Usage: `make delete-gha-logs repository=<repository>`]
ifeq ($(strip $(BINARY_OP)),)
	$(error 🛑 Missing required 1Password CLI)
endif

.SILENT .PHONY: get-gh-rate-limit
get-gh-rate-limit: # get GitHub API rate limit status [Usage: `make get-gh-rate-limit`]
	echo
	echo "Rate Limit for $(STYLE_GROUP_CODE)$(GITHUB_ORG)$(STYLE_RESET):"

ifeq ($(strip $(BINARY_OP)),)
	$(error 🛑 Missing required 1Password CLI)
endif

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
					"/rate_limit" \
			| \
			jq \
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
