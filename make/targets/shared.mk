.SILENT .PHONY: clear
clear:
	clear

.SILENT .PHONY: help
help: # display a list of Make Targets [Usage: `make help`]
	echo
	echo "$(STYLE_BOLD)$(TITLE)$(STYLE_BOLD)"
	echo

	# group 1 = target name: all lowercase characters, dashes, and underscores
	# group 2 = target description: all numbers, characters, dashes, and spaces
	# group 3 = target usage: start with specific string and continue with target name and arguments
	awk \
  	-F ':|#|`' \
  	'BEGIN { \
  		printf "$(STYLE_BOLD)%s$(STYLE_RESET); ", "Target";            \
  		printf "$(STYLE_BOLD)%s$(STYLE_RESET);       ", "Description";    \
  		printf "$(STYLE_BOLD)%s$(STYLE_RESET);", "Usage";                 \
  		print "\n";                                                       \
  	} \
  	/^[a-z0-9_-]+:.*#[^[]*\[Usage: `[^`]*`]/ \
  	{ \
			match($$0, /^[a-z0-9_-]+/); \
			target = substr($$0, RSTART, RLENGTH); \
  		\
			match($$0, /#[[:space:]]([^[]*)\[/); \
			description = substr($$0, RSTART + 2, RLENGTH - 3); \
  		\
			match($$0, /`([^`]*)`/); \
			usage = substr($$0, RSTART + 1, RLENGTH - 2); \
  		\
  		printf "$(STYLE_GROUP_TARGET)%s$(STYLE_RESET); ", target; \
  		printf "%s; ", description; \
  		printf "$(STYLE_GROUP_CODE)`%s`$(STYLE_RESET);\n", usage; \
  	}' \
  	$(MAKEFILE_LIST) \
  	| \
  	column \
  		-c="3" \
  		-s=";" \
  		-t
	echo

.PHONY: _listincludes
_listincludes: # list all included Makefiles and *.mk files [Usage: `make _listincludes`]
	echo
	echo "Currently loaded $(STYLE_GROUP_CODE)*.mk$(STYLE_RESET) files are:"
	echo
	for ITEM in $(MAKEFILE_LIST); do \
		echo " * $(STYLE_GROUP_CODE)$${ITEM}$(STYLE_RESET)"; \
	done
	echo

.SILENT .PHONY: _selfcheck
_selfcheck: # lint Makefile [Usage: `make _selfcheck`]
	echo

	# generates a list of files using `find`, separates the output by a NUL character and passes it to `xargs`
	find \
		$(MAKEFILE_LIST) \
		-type f \
		\( \
			-name 'Makefile' -o \
			-name '*.mk' \
		\) \
		-print0 \
	| \
	xargs \
		-0 \
		-n "1" \
		sh -c '\
			echo "File: $(STYLE_GROUP_CODE)$$0$(STYLE_RESET)" \
			&& \
			checkmake \
				--config=".checkmake.ini" \
				"$$0" \
			&& \
			echo \
		'
