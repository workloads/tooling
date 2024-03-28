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
BINARY_ANSIBLE        ?= ansible-playbook
BINARY_ANSIBLE_GALAXY ?= ansible-galaxy
BINARY_ANSIBLE_LINT   ?= ansible-lint
BINARY_AZ             ?= az
BINARY_CERTBOT        ?= certbot
BINARY_CURL           ?= curl
BINARY_DOCKER         ?= docker
BINARY_GLOW           ?= glow
BINARY_MD5SUM         ?= md5sum
BINARY_OP             ?= op
BINARY_PACKER         ?= packer
BINARY_SCORECARD      ?= scorecard


# configuration files
CONFIG_ANSIBLELINT    ?= .ansible-lint.yml
CONFIG_CHECKMAKE      ?= ../tooling/.checkmake.ini
CONFIG_PACKER_DOCS    ?= .packer-docs.yml

# get current date in YYYYMMDD-HHMMSS format
DATE_CURRENT ?= $(shell date +"%Y%m%d-%H%M%S")
DATE_VERSION ?= $(shell TZ=UTC date +'%Y%m%d-%H%M')

# common linting formats
FORMAT_ANSIBLELINT ?= full # see https://ansible.readthedocs.io/projects/lint/usage/#output-formats
FORMAT_AZ          ?= json # see https://learn.microsoft.com/en-us/cli/azure/format-output-azure-cli?tabs=bash

# 1Password configuration
# see https://developer.1password.com/docs/cli/use-multiple-accounts#use-the-ONEPASSWORD_ACCOUNT-environment-variable
ONEPASSWORD_ACCOUNT      ?= workloads.1password.com
ONEPASSWORD_SECRETS_FILE ?= secrets.op.env

# generate a random string with Bash built-ins, pass it through `md5sum` and limit to a specific length
RANDOM_STRING_LENGTH ?= 4
RANDOM_STRING         = $(shell echo "$${RANDOM}" | $(BINARY_MD5SUM) | head -c $(RANDOM_STRING_LENGTH))

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
  STYLE_BOLD          =
  STYLE_ITALIC        =
  STYLE_FG_GRAY_LIGHT =
  STYLE_FG_GREEN      =
  STYLE_FG_RED        =
  STYLE_FG_WHITE      =
  STYLE_RESET         =

  # groups for compound styling
  STYLE_GROUP_CODE =
endif
