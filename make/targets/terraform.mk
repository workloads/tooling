.SILENT .PHONY: init
init: # initialize and upgrade code for all workspaces [Usage: `make init repository=<repository>`]
ifeq ($(repository),)
	# see https://www.gnu.org/software/make/manual/html_node/Foreach-Function.html
	$(foreach REPOSITORY,$(GITHUB_TERRAFORM_REPOSITORIES),$(call init_workspace,$(strip $(REPOSITORY))))
else
	$(call init_workspace,$(strip $(repository)))
endif

.SILENT .PHONY: lint
lint: # format, validate, and lint code in all workspaces [Usage: `make lint repository=<repository>`]
ifeq ($(repository),)
	# see https://www.gnu.org/software/make/manual/html_node/Foreach-Function.html
	$(foreach REPOSITORY,$(GITHUB_TERRAFORM_REPOSITORIES),$(call lint_workspace,$(strip $(REPOSITORY))))
else
	$(call lint_workspace,$(strip $(repository)))
endif

.SILENT .PHONY: docs
docs: # generate documentation for all workspaces [Usage: `make docs repository=<repository>`]
ifeq ($(repository),)
	# see https://www.gnu.org/software/make/manual/html_node/Foreach-Function.html
	$(foreach REPOSITORY,$(GITHUB_TERRAFORM_REPOSITORIES),$(call render_documentation,$(strip $(REPOSITORY))))
else
	$(call render_documentation,$(strip $(repository)))
endif

.SILENT .PHONY: mirror
mirror: # create mirror of Terraform Provider binaries [Usage: `make mirror repository=<repository>`]
ifeq ($(repository),)
	# see https://www.gnu.org/software/make/manual/html_node/Foreach-Function.html
	$(foreach REPOSITORY,$(GITHUB_TERRAFORM_REPOSITORIES),$(call mirror_providers,$(strip $(REPOSITORY))))
else
	$(call mirror_providers,$(strip $(repository)))
endif
