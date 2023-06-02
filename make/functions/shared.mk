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

# generate documentation for input files by rendering them with terraform-docs
define render_documentation
	$(call print_reference,$(1))

	# copy input files (with a non-.tf extension) to an identical file with a .tf extension
	$(foreach FILE,$(2),cp "$(1)/$(FILE)" "$(1)/$(basename $(FILE)).temporary.tf")

	# render documentation using terraform-docs
	terraform-docs \
		"$(strip $(1))" \
		--config="$(3)" \

	# remove temporary files
	$(foreach FILE,$(2),rm "$(1)/$(basename $(FILE)).temporary.tf")
endef

# create a directory if it does not exist
define safely_create_directory
	$(call print_reference,$(1))

	# create directory if it does not exist
	mkdir -p "$(1)";
endef
