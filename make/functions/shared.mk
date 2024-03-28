# commonly available functions for use in Makefiles
BINARY_GREP ?= grep


# fail if argument is missing
#
#		expected arguments:
#		$(1) - missing argument
define missing_argument
	$(error 🛑  Missing argument for `$(MAKECMDGOALS)`. Specify with `make $(MAKECMDGOALS) $(1)`)
endef

# pretty-print a single CLI arguments, if supplied
#
#		expected arguments:
#			$(1) - argument to pretty-print
define print_arg
	echo "🔧️ Executing with argument \`$(STYLE_GROUP_CODE)$(1)$(STYLE_RESET)\` with value \`$(STYLE_GROUP_CODE)$(2)$(STYLE_RESET)\`"
endef

# pretty-print pass-through CLI arguments, if supplied
#
#		expected arguments:
#			$(1) - arguments to pretty-print
define print_args
	if [ ! -z "$(ARGS)" ]; then \
		echo "🔧️ Executing with arguments \`$(STYLE_GROUP_CODE)$(ARGS)$(STYLE_RESET)\`"; \
	fi

	if [ ! -z "$(cli_args)" ]; then \
		echo "🔧️ Executing with CLI arguments \`$(STYLE_GROUP_CODE)$(cli_args)$(STYLE_RESET)\`"; \
	fi
endef

# print environment variables matching a specific string
#
#		expected arguments:
#			$(1) - string to
define print_env
	env | \
		$(BINARY_GREP) \
		"$(1)" \
	;
endef

# pretty-print a reference (file path, directory, etc.)
#
#		expected arguments:
#			$(1) - reference to print
define print_reference
	echo "⚠️  Processing \`$(STYLE_GROUP_CODE)$(1)$(STYLE_RESET)\`..."
endef

# generate documentation for input files by rendering them with terraform-docs
#
#			expected arguments:
#			$(1) - directory containing input files
#			$(2) - input files to render
#			$(3) - path to terraform-docs configuration file
#			$(4) - path to sample variables file
define render_documentation
	$(call print_reference,$(1))

	# copy input files (with a non-.tf extension) to an identical file with a .tf extension
	$(foreach FILE,$(2),cp "$(1)/$(FILE)" "$(1)/$(basename $(FILE)).temporary.tf")

	# render documentation using terraform-docs
	$(BINARY_TERRAFORM_DOCS) \
		"$(strip $(1))" \
		--config="$(3)" \
	;

	# create sample variable files using terraform-docs
	# see https://terraform-docs.io/how-to/generate-terraform-tfvars/
#	$(if $(strip $(4)), \
#		$(BINARY_TERRAFORM_DOCS) \
#			tfvars \
#				hcl \
#				"$(strip $(1))" \
#	  > "$(strip $(1))/$(4)" \
#	)

	# remove temporary files
	$(foreach FILE,$(2),rm "$(1)/$(basename $(FILE)).temporary.tf") \
	;
endef
