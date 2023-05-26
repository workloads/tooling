# Makefile for general maintenance

# configuration
TITLE = 🔧 MAINTENANCE

include ./make/configs/shared.mk

include ./make/functions/shared.mk

# include Terraform-generated configuration data
include ./make/configs/github.mk

include ./make/functions/maintenance.mk

include ./make/targets/shared.mk

.SILENT .PHONY: init
init: # initialize and upgrade code for all workspaces [Usage: `make init`]
	# see https://www.gnu.org/software/make/manual/html_node/Foreach-Function.html
	$(foreach REPOSITORY,$(GITHUB_REPOSITORIES),$(call init_workspace,$(strip $(REPOSITORY))))

.SILENT .PHONY: lint
lint: # format, validate, and lint code in all workspaces [Usage: `make lint`]
	# see https://www.gnu.org/software/make/manual/html_node/Foreach-Function.html
	$(foreach REPOSITORY,$(GITHUB_REPOSITORIES),$(call lint_workspace,$(strip $(REPOSITORY))))

.SILENT .PHONY: docs
docs: # generate documentation for all workspaces [Usage: `make docs`]
	# see https://www.gnu.org/software/make/manual/html_node/Foreach-Function.html
	$(foreach REPOSITORY,$(GITHUB_REPOSITORIES),$(call render_documentation,$(strip $(REPOSITORY))))

.SILENT .PHONY: pull
pull: # pull latest changes for all repositories [Usage: `make pull`]
	$(foreach REPOSITORY,$(GITHUB_REPOSITORIES),$(call git_pull,$(strip $(REPOSITORY))))

.SILENT .PHONY: scorecards
scorecards: # generate OpenSSF Scorecards [Usage: `make scorecards`]
	# see https://www.gnu.org/software/make/manual/html_node/Foreach-Function.html
	$(foreach REPOSITORY,$(GITHUB_REPOSITORIES),$(call generate_scorecard,$(strip $(REPOSITORY))))

.SILENT .PHONY: delete-gha-logs
delete-gha-logs: # delete GitHub Actions Logs for all repositories [Usage: `make delete-gha-logs`]
	# see https://www.gnu.org/software/make/manual/html_node/Foreach-Function.html
	$(foreach REPOSITORY,$(GITHUB_REPOSITORIES),$(call delete_github_actions_logs,$(strip $(REPOSITORY))))

.SILENT .PHONY: get-gh-rate-limit
get-gh-rate-limit: # get GitHub API rate limit status [Usage: `make get-gh-rate-limit`]
	echo
	echo "Rate Limit for $(STYLE_GROUP_CODE)$(GITHUB_ORG)$(STYLE_RESET):"
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
