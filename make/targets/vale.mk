# Vale-specific Make Targets

BINARY_VALE ?= vale
CONFIG_VALE ?= ../tooling/.vale.ini
VALE_PATH   ?= *.md


.SILENT .PHONY: vale
vale: # lint prose with Vale [Usage: `make vale`]
	$(BINARY_VALE) \
		--config=$(CONFIG_VALE) \
		$(VALE_PATH) \
	;

.SILENT .PHONY: vale-sync
vale-sync: # sync Vale dependencies [Usage: `make vale-sync`]
	$(BINARY_VALE) \
		sync \
			--config=$(CONFIG_VALE) \
	;
