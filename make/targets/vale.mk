# Vale-specific Make Targets

BINARY_VALE ?= vale
CONFIG_VALE ?= ../tooling/.vale.ini
VALE_PATH   ?= *.md


.SILENT .PHONY: vale_lint
vale_lint: # lint prose with Vale [Usage: `make vale_lint`]
	$(BINARY_VALE) \
		--config=$(CONFIG_VALE) \
		$(VALE_PATH)

.SILENT .PHONY: vale_sync
vale_sync: # sync Vale dependencies [Usage: `make vale_sync`]
	$(BINARY_VALE) \
		sync \
			--config=$(CONFIG_VALE) \
