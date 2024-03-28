# Python-specific Make functions

BINARY_AUTOPEP8     ?= autopep8
BINARY_FLAKE8       ?= flake8
BINARY_PIP          ?= pip3
BINARY_PYLINT       ?= pylint
BINARY_PYTHON       ?= python3
CONFIG_FLAKE8       ?= .flake8
CONFIG_PIP_REQS     ?= requirements.txt
CONFIG_PIP_REQS_DEV ?= requirements-dev.txt
CONFIG_PYLINT       ?= .pylintrc

# install pip requirements from file
#
#		expected arguments:
#			$(1) - requirements file to use
define pip_install
	$(call print_reference,$(1))

	$(BINARY_PIP) \
		install \
			--requirement "$(1)" \
	;
endef

# fix Python files using autopep8
#
#		expected arguments:
#			n/a
define python_fix
	$(BINARY_AUTOPEP8) \
		--in-place \
		*.py \
	;
endef

# lint Python files using Flake8 and Pylint
#
#		expected arguments:
#			n/a
define python_lint
	$(BINARY_FLAKE8) \
		--config="${CONFIG_FLAKE8}" \
		*.py \
	;

	$(BINARY_PYLINT) \
		--rcfile="${CONFIG_PYLINT}" \
		*.py \
	;
endef
