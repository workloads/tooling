# check for presence of binary on `$PATH` and return binary name
define check_for_binary
    $(if $(shell which $(1)),"$(1)",)
endef

define check_for_binary
    $(if $(shell which $(1)),"$(1)",)
endef

# create a directory if it does not exist
define safely_create_directory
	$(call print_reference,$(1))

	# create directory if it does not exist
	mkdir -p "$(1)";
endef

# pretty-print a reference (file path, directory, etc.)
define print_reference
	echo "⚠️ Processing \`$(STYLE_GROUP_CODE)$(1)$(STYLE_RESET)\`..."
endef

# fail if argument is missing
define missing_argument
	$(error 🛑 Missing argument for `$(1)`. Specify with `make $(1) $(2)`)
endef
