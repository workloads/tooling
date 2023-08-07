# see https://www.gnu.org/software/make/manual/html_node/Options_002fRecursion.html
MAKEFLAGS = --no-builtin-rules --silent --warn-undefined-variables

# see https://www.gnu.org/software/make/manual/html_node/Choosing-the-Shell.html
SHELL       := sh
.SHELLFLAGS := -eu -c

# see https://www.gnu.org/software/make/manual/html_node/Goals.html
.DEFAULT_GOAL := help

# see https://www.gnu.org/software/make/manual/html_node/One-Shell.html
.ONESHELL :

# required / optional binaries
BINARY_OP = $(call check_for_binary,op)

# get current date in YYYYMMDD-HHMMSS format
CURRENT_DATE  = $(shell date +"%Y%m%d-%H%M%S")

# 1Password-specific configuration
# see https://developer.1password.com/docs/cli/use-multiple-accounts#use-the-op_account-environment-variable
OP_ACCOUNT = workloads.1password.com

# generate a random string with Bash built-ins, pass it through `md5sum` and limit to a specific length
RANDOM_STRING_LENGTH ?= 4
RANDOM_STRING         = $(shell echo "$${RANDOM}" | md5sum | head -c $(RANDOM_STRING_LENGTH))

# check if environment variable `NO_COLOR` is set to a non-empty value
ifeq ($(strip $(shell echo "$(NO_COLOR)")),)
	# `NO_COLOR` is set to an empty value, colorize CLI output
	STYLE_BG_GRAY_LIGHT = \033[47m
  STYLE_BOLD          = \033[1m
  STYLE_ITALIC        = \033[3m
  STYLE_FG_GRAY_LIGHT = \033[37m
  STYLE_FG_GREEN      = \033[32m
  STYLE_FG_RED        = \033[31m
  STYLE_FG_WHITE      = \033[97m
  STYLE_RESET         = \033[0m

  # groups for compound styling
  STYLE_GROUP_TARGET = $(STYLE_BOLD)
  STYLE_GROUP_CODE   = $(STYLE_BG_GRAY_LIGHT)$(STYLE_ITALIC)
else
	STYLE_BG_GRAY_LIGHT =
  STYLE_BOLD =
  STYLE_ITALIC =
  STYLE_FG_GRAY_LIGHT =
  STYLE_FG_GREEN =
  STYLE_FG_RED =
  STYLE_FG_WHITE =
  STYLE_RESET =

  # groups for compound styling
	STYLE_GROUP_CODE =
endif
