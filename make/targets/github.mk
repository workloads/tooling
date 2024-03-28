.SILENT .PHONY: pull
pull: # pull latest changes for all repositories [Usage: `make pull`]
	$(foreach REPOSITORY,$(GITHUB_REPOSITORIES),$(call git_pull,$(strip $(REPOSITORY))))

.SILENT .PHONY: checkout
checkout: # check out all (public and private) repositories [Usage: `make checkout`]
	$(foreach REPOSITORY,$(GITHUB_REPOSITORIES),$(call git_checkout,$(strip $(REPOSITORY))))

.SILENT .PHONY: delete-gha-logs
delete-gha-logs: # delete GitHub Actions Logs for all repositories [Usage: `make delete-gha-logs repository=<repository>`]
ifeq ($(repository),)
	# see https://www.gnu.org/software/make/manual/html_node/Foreach-Function.html
	$(foreach REPOSITORY,$(GITHUB_REPOSITORIES),$(call github_delete_actions_logs,$(strip $(REPOSITORY))))
else
	$(call github_delete_actions_logs,$(strip $(repository)))
endif

.SILENT .PHONY: get-gh-rate-limit
get-gh-rate-limit: # get GitHub API rate limit status [Usage: `make get-gh-rate-limit`]
	echo
	echo "Rate Limit for $(STYLE_GROUP_CODE)$(GITHUB_ORG)$(STYLE_RESET):"

	$(call github_get_api_rate_limit_status)
