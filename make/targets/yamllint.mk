# YAMLLint-specific Make Targets

# see https://yamllint.readthedocs.io/en/stable/quickstart.html#running-yamllint

BINARY_YAMLLINT ?= yamllint
CONFIG_YAMLLINT ?= .yaml-lint.yml
FORMAT_YAMLLINT ?= colored


.SILENT .PHONY: lint-yaml
lint-yaml: # lint YAML files using yamllint [Usage: `make lint-yaml`]
	$(BINARY_YAMLLINT) \
		--config-file "$(CONFIG_YAMLLINT)" \
		--format "$(FORMAT_YAMLLINT)" \
		--strict \
		.
