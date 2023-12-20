# Vale-specific Makefile targets

VALE_CONFIG  = ../tooling/.vale.ini
VALE_PATH   ?= *.md

.SILENT .PHONY: vale_lint
vale_lint: # lint prose with Vale [Usage: `make vale_lint`]
	vale \
		--config=$(VALE_CONFIG) \
		$(VALE_PATH)

.SILENT .PHONY: vale_sync
vale_sync: # sync Vale dependencies [Usage: `make vale_sync`]
	vale \
		sync \
			--config=$(VALE_CONFIG) \
