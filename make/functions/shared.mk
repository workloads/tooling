# pretty-print a reference (file path, directory, etc.)
define print_reference
	echo
	echo "⚠️ Processing \`$(STYLE_GROUP_CODE)$(1)$(STYLE_RESET)\`..."
	echo
endef

# fail if command is missing
define missing_subcommand
	$(error 🛑 Missing subcommand for `$(STYLE_GROUP_CODE)$(1)$(STYLE_RESET)`. Specify with `make $(1) $(2)`)
endef
