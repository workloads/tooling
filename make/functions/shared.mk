# pretty-print a reference (file path, directory, etc.)
define print_reference
	echo
	echo "⚠️ Processing \`$(STYLE_GROUP_CODE)$(1)$(STYLE_RESET)\`..."
	echo
endef

# fail if command is missing
define missing_command
	$(error 🛑 Missing command for `$(1)`. Specify with `make $(1) $(2)`)
endef
