# process files with `hclfmt`
#
#		expected arguments:
#			$(1) - file to format
define format_with_hclfmt
	$(call print_reference,$(1))

  $(BINARY_HCLFMT) \
  	-w \
  	"$(strip $(1))" \
	;
endef
