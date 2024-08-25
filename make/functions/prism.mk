# Prism-specific Make functions

BINARY_PRISM ?= prism
HOST_PRISM ?= "0.0.0.0"

# render OAS mock using prism
#
#		expected arguments:
#			$(1) - OAS file to mock
#     $(2) - port to listen on
define prism_mock
	$(call print_reference,$(1))

	$(BINARY_PRISM) \
		mock \
			--host "0.0.0.0" \
			--port "${2}" \
			--errors \
			"${1}" \
	;
endef
