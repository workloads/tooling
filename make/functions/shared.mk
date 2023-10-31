# check for presence of binary on `$PATH` and return binary name
# expected argument:
# $(1) - binary to check for
define check_for_binary
	$(if $(shell which $(1)),"$(1)",)
endef

# fail if argument is missing
define missing_argument
	$(error 🛑  Missing argument for `$(MAKECMDGOALS)`. Specify with `make $(MAKECMDGOALS) $(1)`)
endef

# pretty-print a reference (file path, directory, etc.)
# expected argument:
# $(1) - reference to print
define print_reference
	echo "⚠️  Processing \`$(STYLE_GROUP_CODE)$(1)$(STYLE_RESET)\`..."
endef

# pretty-print a single CLI arguments, if supplied
# expected argument:
# $(1) - argument to pretty-print
define print_arg
	echo "🔧️ Executing with argument \`$(STYLE_GROUP_CODE)$(1)$(STYLE_RESET)\` with value \`$(STYLE_GROUP_CODE)$(2)$(STYLE_RESET)\`"
endef

# pretty-print pass-through CLI arguments, if supplied
# expected argument:
# $(1) - arguments to pretty-print
define print_args
	if [ ! -z "$(ARGS)" ]; then \
		echo "🔧️ Executing with arguments \`$(STYLE_GROUP_CODE)$(ARGS)$(STYLE_RESET)\`"; \
	fi
endef

# print sanitized secrets using OP CLI and envo
# expected argument:
# $(1) - secret to print
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

# process HCL files with `hclfmt`
# expected argument:
# $(1) - file to format
define format_hcl_files
	$(call print_reference,$(1))

  $(shell $(BINARY_HCLFMT) -w "$(strip $(1))")
endef

# create a directory if it does not exist
# expected argument:
# $(1) - directory to create
define safely_create_directory
	$(call print_reference,$(1))

	# create directory if it does not exist
	mkdir -p "$(1)";
endef

# delete a file or directory at the specified path
# expected argument:
# $(1) - file to delete
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
