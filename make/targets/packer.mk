# Packer-specific Makefile targets

.SILENT .PHONY: yaml_lint
yaml_lint: # lint YAML files [Usage: `make yaml_lint`]
	$(call yaml_lint)
