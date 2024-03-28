# delete a file or directory at the specified path
#
#		expected arguments:
#			$(1) - file to delete
define delete_target
	echo "🗑️  Deleting the following files:"

	# remove target and verbosely print affected files
	rm \
		-d \
		-f \
		-r \
		-v \
		"$(1)"

	echo
endef

# create a directory if it does not exist
#
#		expected arguments:
#			$(1) - directory to create
define safely_create_directory
	$(call print_reference,$(1))

	# create directory if it does not exist
	mkdir \
		-p \
		"$(1)";
endef
