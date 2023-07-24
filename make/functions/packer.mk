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
