# Terraform-specific Make Functions

# file-specific configuration
BINARY_TERRAFORM      ?= terraform
BINARY_TERRAFORM_DOCS ?= terraform-docs
BINARY_TFLINT         ?= tflint
CONFIG_TERRAFORM_DOCS ?= .terraform-docs.yml
CONFIG_TFLINT         ?= .tflint.hcl
DIR_TERRAFORM_PLUGINS ?= $(HOME)/.terraform.d/plugins
FORMAT_TFLINT         ?= compact # see https://github.com/terraform-linters/tflint/blob/master/docs/user-guide/config.md#format
WORKING_DIR            = ..


# initialize and upgrade (all) Terraform workspaces
#
#		expected arguments:
#		$(1) - workspace to initialize and upgrade
define init_workspace
	$(call print_reference,$(1))

	# see https://developer.hashicorp.com/terraform/cli/commands/init
	$(BINARY_TERRAFORM) \
		-chdir="$(WORKING_DIR)/$(1)" \
		init \
			-get=true \
			-input=false \
			-plugin-dir="$(DIR_TERRAFORM_PLUGINS)" \
			-upgrade \
	;

	# see https://developer.hashicorp.com/terraform/cli/commands/providers/lock#specifying-target-platforms
	$(BINARY_TERRAFORM) \
		-chdir="$(WORKING_DIR)/$(1)" \
		providers \
			lock \
				-fs-mirror="$(DIR_TERRAFORM_PLUGINS)" \
				-platform="darwin_amd64" \
				-platform="darwin_arm64" \
				-platform="linux_amd64"	\
				-platform="linux_arm64"	\
				-platform="windows_amd64" \
				-platform="windows_arm64" \
	;

	# see https://github.com/terraform-linters/tflint#usage
	$(BINARY_TFLINT) \
		--chdir="$(WORKING_DIR)/$(1)" \
		--init \
	;

	echo \
	;
endef

# initialize and upgrade all workspaces
#
#		expected arguments:
#			$(1) - providers to mirror
define mirror_providers
	$(call print_reference,$(1))

	# see https://developer.hashicorp.com/terraform/cli/commands/providers/lock#specifying-target-platforms
	$(BINARY_TERRAFORM) \
		-chdir="$(WORKING_DIR)/$(1)" \
		providers \
			mirror \
				-platform="darwin_amd64" \
				-platform="darwin_arm64" \
				-platform="linux_amd64"	\
				-platform="linux_arm64"	\
				-platform="windows_amd64" \
				-platform="windows_arm64" \
				"$(DIR_TERRAFORM_PLUGINS)" \
	;

	echo \
	;
endef

# format, validate, and lint code in all workspaces
#
#		expected arguments:
#			$(1) - workspace to lint
define lint_workspace
	$(call print_reference,$(1))

	# see https://developer.hashicorp.com/terraform/cli/commands/fmt
	$(BINARY_TERRAFORM) \
		-chdir="$(WORKING_DIR)/$(1)" \
		fmt \
			-recursive \
	;

	# see https://developer.hashicorp.com/terraform/cli/commands/validate
	$(BINARY_TERRAFORM) \
		-chdir="$(WORKING_DIR)/$(1)" \
		validate
	;

	# see https://github.com/terraform-linters/tflint#usage
	$(BINARY_TFLINT) \
		--chdir="$(WORKING_DIR)/$(1)" \
		--config="$(CONFIG_TFLINT)" \
		--format="$(FORMAT_TFLINT)" \
		--no-module \
	;
endef

# generate documentation for all workspaces
#
#		expected arguments:
#			$(1) - target to render documentation for
define render_documentation
	$(call print_reference,$(1))

	# see https://terraform-docs.io/reference/terraform-docs/
	$(BINARY_TERRAFORM_DOCS) \
		--config="$(WORKING_DIR)/$(1)/$(CONFIG_TERRAFORM_DOCS)" \
		"$(WORKING_DIR)/$(1)" \
	;
endef
