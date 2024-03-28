# Snyk-specific Make functions

BINARY_SNYK ?= snyk
SNYK_ORG    ?= workloads

# test files using Snyk Container
#
#		expected arguments:
#			$(1) - image name / identifier
#			$(2) - output path for SARIF file (without extension)
define snyk_container
	$(call print_reference,$(1))

	# see https://docs.snyk.io/snyk-cli/commands/container-test
	$(BINARY_SNYK) \
		container \
			test \
				--app-vulns \
				--fail-on=all \
				--org="$(SNYK_ORG)" \
				--print-deps \
				--sarif-file-output="$(2).sarif" \
				"$(1)"

	echo
endef

# test files using Snyk Test
#
#		expected arguments:
#			$(1) - command to use for testing
#			$(2) - package / dependencies file to test
#			$(3) - package manager to use for testing
#			$(4) - additional arguments to pass to the test command
define snyk_test
	$(call print_reference,$(2))

	# see https://docs.snyk.io/snyk-cli/commands/test
	$(BINARY_SNYK) \
		test \
			--fail-fast \
			--dev \
			--org=$(SNYK_ORG) \
			--command=$(1) \
			--file=$(2) \
			--package-manager=$(3) \
			-- $(4)

	echo
endef
