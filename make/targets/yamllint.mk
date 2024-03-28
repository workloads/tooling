# YAMLLint-specific Make Targets

BINARY_YAMLLINT ?= yamllint
CONFIG_YAMLLINT ?= .yaml-lint.yml
FORMAT_YAMLLINT ?= colored # see https://yamllint.readthedocs.io/en/stable/quickstart.html#running-yamllint


.SILENT .PHONY: yaml_lint
yaml_lint: # lint YAML files [Usage: `make yaml_lint`]
	$(BINARY_YAMLLINT) \
		--config-file "$(CONFIG_YAMLLINT)" \
		--format "$(FORMAT_YAMLLINT)" \
		--strict \
		.
