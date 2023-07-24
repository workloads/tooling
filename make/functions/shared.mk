# check for presence of binary on `$PATH` and return binary name
define check_for_binary
	$(if $(shell which $(1)),"$(1)",)
endef

# fail if argument is missing
define missing_argument
	$(error 🛑  Missing argument for `$(1)`. Specify with `make $(1) $(2)`)
endef

# pretty-print a reference (file path, directory, etc.)
define print_reference
	echo "⚠️  Processing \`$(STYLE_GROUP_CODE)$(1)$(STYLE_RESET)\`..."
endef

# pretty-print a single CLI arguments, if supplied
define print_arg
	echo "🔧️ Executing with argument \`$(STYLE_GROUP_CODE)$(1)$(STYLE_RESET)\` with value \`$(STYLE_GROUP_CODE)$(2)$(STYLE_RESET)\`"
endef

# pretty-print pass-through CLI arguments, if supplied
define print_args
	if [ ! -z "$(ARGS)" ]; then \
		echo "🔧️ Executing with arguments \`$(STYLE_GROUP_CODE)$(1)$(STYLE_RESET)\`"; \
	fi
endef

# print sanitized secrets using OP CLI and envo
define print_secrets
	# see https://developer.1password.com/docs/cli/reference/commands/run
	op \
		run \
		  --account="$(OP_ACCOUNT)" \
			--env-file="$(OP_ENV_FILE)" \
			--no-masking \
			-- \
			envo --truncLength=3 | \
			grep "$(1)"
endef

# generate documentation for input files by rendering them with terraform-docs
# expected arguments:
# $(1) - directory containing input files
# $(2) - input files to render
# $(3) - path to terraform-docs configuration file
# $(4) - path to sample variables file
define render_documentation
	$(call print_reference,$(1))

	# copy input files (with a non-.tf extension) to an identical file with a .tf extension
	$(foreach FILE,$(2),cp "$(1)/$(FILE)" "$(1)/$(basename $(FILE)).temporary.tf")

	# render documentation using terraform-docs
	terraform-docs \
		"$(strip $(1))" \
		--config="$(3)"

	# create sample variable files using terraform-docs
	# see https://terraform-docs.io/how-to/generate-terraform-tfvars/
#	$(if $(strip $(4)), \
#		terraform-docs \
#			tfvars \
#				hcl \
#				"$(strip $(1))" \
#	  > "$(strip $(1))/$(4)" \
#	)

	# remove temporary files
	$(foreach FILE,$(2),rm "$(1)/$(basename $(FILE)).temporary.tf") \
	;
endef

# create a directory if it does not exist
define safely_create_directory
	$(call print_reference,$(1))

	# create directory if it does not exist
	mkdir -p "$(1)";
endef

# delete a file or directory at the specified path
define delete_target_path
	echo "🗑️ Deleting the following files:"

	# remove target and verbosely print affected files
	rm \
		-d \
		-f \
		-r \
		-v \
		"$(1)"

	echo
endef

# lint YAML files
define yaml_lint
	$(BINARY_YAMLLINT) \
		--config-file "$(YAMLLINT_CONFIG)" \
		--format "$(YAMLLINT_FORMAT)" \
		--strict \
		.
endef
