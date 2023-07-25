# initialize a Packer Template
define packer_init
	# see https://developer.hashicorp.com/packer/docs/commands/init
	$(BINARY_PACKER) \
		init \
			-upgrade \
			$(ARGS) \
			"$(1)"
endef

# build a Packer Template
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
define packer_build_with_secrets
	# see https://developer.1password.com/docs/cli/reference/commands/run
	# and https://developer.hashicorp.com/packer/docs/commands/build
	op \
		run \
			--account="$(OP_ACCOUNT)" \
			--env-file="$(OP_ENV_FILE)" \
			-- \
				$(BINARY_PACKER) \
					build \
						-warn-on-undeclared-var \
						$(cli_args) \
						$(ARGS) \
						"$(1)"
endef

# start Console for a Packer Template
define packer_console
	# see https://developer.hashicorp.com/packer/docs/commands/console
	$(BINARY_PACKER) \
		console \
			$(cli_args) \
			$(ARGS) \
			"$(1)"
endef

# lint a Packer Template
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
