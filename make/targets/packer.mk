# Packer-specific Make Targets

.SILENT .PHONY: _link_vars
_link_vars: # create a symlink to the shared variables file for a new builder [Usage: `make _link_vars builder=<builder>`]
	$(if $(builder),,$(call missing_argument,builder=<builder>))

	$(call safely_create_directory,$(DIR_PACKER)/$(builder))

	# remove and unlink existing file (`-F` and `-f`),
	# write to stderr if the target exists (`-i`),
	# attempt to create a soft symbolic link (`-P` and `-s`)
	#	verbosely describe the operations (`-v` and `-w`)
	$(foreach shared_file,$(FILES_SHARED),\
		ln \
				-F -f -P -i -s -v "../${shared_file}"  "$(DIR_BUILD)/${shared_file}"; \
	)
