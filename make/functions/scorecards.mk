# generate OpenSSF Scorecard
#	 expected arguments:
#	 $(1) - repository to generate scorecard for
define generate_scorecard
	$(call print_reference,$(1))

	# see https://github.com/ossf/scorecard#scorecard-command-line-interface
	# and https://developer.1password.com/docs/cli/reference/commands/run
	$(BINARY_OP) \
		run \
			--account="$(ONEPASSWORD_ACCOUNT)" \
			--env-file="$(ONEPASSWORD_SECRETS_FILE)" \
			-- \
			scorecard \
				--checks="$(SCORECARD_CHECKS)" \
				--repo="github.com/$(GITHUB_ORG)/$(1)" \
				--show-details \
			&& \
			echo "--------------------\n" \
	;
endef
