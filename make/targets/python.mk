include ../tooling/make/functions/python.mk

.SILENT .PHONY: deps
deps: # install Python dependencies using pip [Usage: `make deps`]
	$(call pip_install,$(CONFIG_PIP_REQS))

.SILENT .PHONY: deps-dev
deps-dev: # install Python development dependencies using pip [Usage: `make deps-dev`]
	$(call pip_install,$(CONFIG_PIP_REQS_DEV))

.SILENT .PHONY: fix
fix: # fix Python files using autopep8 [Usage: `make fix`]
	$(call python_fix)

.SILENT .PHONY: lint
lint: # lint Python files using Flake8 and Pylint [Usage: `make lint`]
	$(call python_lint)
