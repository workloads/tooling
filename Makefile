# Makefile for general maintenance

# configuration
CERTIFICATE_EMAIL       ?= "hostmaster"
CERTIFICATE_SERVER      ?= "https://acme-v02.api.letsencrypt.org/directory"
DIR_CERTIFICATE_CHAIN   ?= ./certificates/$(domain)
OP_ENV_FILE              = secrets.op.env
TITLE                    = 🔧 MAINTENANCE
VAULT_MOUNT             ?= "tls-certificates"
VAULT_NAMESPACE         ?= "admin"

include ./make/configs/shared.mk

include ./make/functions/shared.mk

# include Terraform-generated configuration data
include ./make/configs/github.mk

include ./make/functions/maintenance.mk

include ./make/targets/terraform.mk
include ./make/targets/github.mk
include ./make/targets/shared.mk

.SILENT .PHONY: scorecards
scorecards: # generate OpenSSF Scorecards [Usage: `make scorecards target=<repository>`]
ifeq ($(strip $(BINARY_OP)),)
	$(error 🛑 Missing required 1Password CLI)
endif

ifeq ($(repository),)
	$(foreach REPOSITORY,$(GITHUB_TERRAFORM_REPOSITORIES),$(call generate_scorecard,$(strip $(REPOSITORY))))
else
	$(call generate_scorecard,$(strip $(repository)))
endif

ifeq ($(repository),)
	# see https://www.gnu.org/software/make/manual/html_node/Foreach-Function.html
	$(foreach REPOSITORY,$(GITHUB_REPOSITORIES),$(call delete_github_actions_logs,$(strip $(REPOSITORY))))
else
	$(call delete_github_actions_logs,$(strip $(repository)))
endif

.SILENT .PHONY: request-cert
request-cert: # request a wildcard certificate from Let's Encrypt [Usage: `make request-cert domain=<domain>`]
	$(if $(domain),,$(call missing_argument,domain=<domain>))

	# create directory for certificates output
	$(call safely_create_directory,$(DIR_CERTIFICATE_CHAIN))

	# request a wildcard certificate for `<domain>` and `*.<domain>`
	# see https://eff-certbot.readthedocs.io/en/stable/using.html#manual
	certbot \
		certonly \
			--agree-tos \
			--config-dir="$(DIR_CERTIFICATE_CHAIN)" \
			--domains "$(domain),*.$(domain)" \
			--email "$(CERTIFICATE_EMAIL)@$(domain)" \
			--logs-dir="$(DIR_CERTIFICATE_CHAIN)" \
			--manual \
			--preferred-challenges="dns" \
			--renew-by-default \
			--rsa-key-size="4096" \
			--server "$(CERTIFICATE_SERVER)" \
			--test-cert \
			--work-dir="$(DIR_CERTIFICATE_CHAIN)"

.SILENT .PHONY: get-cert
get-cert: # retrieve a wildcard certificate from Vault [Usage: `make get-cert domain=<domain>`]
	$(if $(domain),,$(call missing_argument,domain=<domain>))

	# see https://developer.hashicorp.com/vault/docs/commands/kv/get
	vault \
		kv \
			get \
				-namespace="$(VAULT_NAMESPACE)" \
				-mount="$(VAULT_MOUNT)" \
				"$(domain)"

.SILENT .PHONY: put-cert
put-cert: # store a wildcard certificate from Let's Encrypt in Vault [Usage: `make store-cert domain=<domain>`]
	$(if $(domain),,$(call missing_argument,domain=<domain>))

	# see https://developer.hashicorp.com/vault/docs/commands/kv/put
	vault \
		kv \
			put \
				-namespace="$(VAULT_NAMESPACE)" \
				-mount="$(VAULT_MOUNT)" \
				"$(domain)"
