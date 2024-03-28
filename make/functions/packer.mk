# initialize a Packer Template
# expected argument:
# $(1) - directory to initialize
define packer_init
	# see https://developer.hashicorp.com/packer/docs/commands/init
	$(BINARY_PACKER) \
		init \
			-upgrade \
			$(ARGS) \
			"$(1)"
endef

# build a Packer Template
# expected argument:
# $(1) - template to build
define packer_build
	# see https://developer.hashicorp.com/packer/docs/commands/build
	$(BINARY_PACKER) \
		build \
			-warn-on-undeclared-var \
			$(cli_args) \
			$(ARGS) \
			"$(1)"
endef

# build a Packer Template after injecting secrets
# expected argument:
# $(1) - workspace to build, with secrets injected
define packer_build_with_secrets
	# see https://developer.1password.com/docs/cli/reference/commands/run
	# and https://developer.hashicorp.com/packer/docs/commands/build
	$(BINARY_OP) \
		run \
			--account="$(ONEPASSWORD_ACCOUNT)" \
			--env-file="$(ONEPASSWORD_SECRETS_FILE)" \
			-- \
				$(BINARY_PACKER) \
					build \
						-warn-on-undeclared-var \
						$(cli_args) \
						$(ARGS) \
						"$(1)"
endef

# start Console for a Packer Template
# expected argument:
# $(1) - directory to start Packer Console for
define packer_console
	# see https://developer.hashicorp.com/packer/docs/commands/console
	$(BINARY_PACKER) \
		console \
			$(cli_args) \
			$(ARGS) \
			"$(1)"
endef

# lint a Packer Template
# expected argument:
# $(1) - directory to lint
define packer_lint
	# see https://developer.hashicorp.com/packer/docs/commands/fmt
  # and https://developer.hashicorp.com/packer/docs/commands/validate
	$(BINARY_PACKER) \
		fmt \
			-diff \
			-recursive \
			"$(1)" \
	&& \
	$(BINARY_PACKER) \
		validate \
			$(cli_args) \
			$(ARGS) \
			"$(1)" \
	;
endef
