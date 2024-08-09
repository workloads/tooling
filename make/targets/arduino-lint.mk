# arduino-lint-specific Make Targets

BINARY_ARDUINO_LINT ?= arduino-lint

FORMAT_ARDUINO_LINT ?= text


.SILENT .PHONY: lint-arduino
lint-arduino: # lint Arduino code using arduino-lint [Usage: `make lint-arduino`]
	$(BINARY_ARDUINO_LINT) \
		--compliance strict \
		--format $(FORMAT_ARDUINO_LINT) \
		--library-manager update \
		--project-type all \
	;
