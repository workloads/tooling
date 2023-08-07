# Azure CLI-specific Makefile targets

# default AZ CLI output format (other options include: `table`, `tsv`, `yaml`)
AZ_OUTPUT ?= json

# set sensible defaults for Azure Service Principal configuration
AZ_SERVICEPRINCIPAL_NAME ?= "terraform-$(RANDOM_STRING)"
AZ_SERVICEPRINCIPAL_ROLE ?= "Contributor"

# retrieve Account Email from currently authenticated Azure Account
AZ_ACCOUNT_EMAIL = $(shell az account show --output "$(AZ_OUTPUT)" --query 'user.name')

# retrieve Subscription ID from currently authenticated Azure Account, using Account Email
AZ_SUBSCRIPTION_ID = $(shell az account list --output "$(AZ_OUTPUT)" --query "[?user.name == '$(AZ_ACCOUNT_EMAIL)']|[0].id")

# see https://portal.azure.com/#view/Microsoft_Azure_Billing/SubscriptionsBlade
.SILENT .PHONY: get-az-subscription
get-az-subscription: # get Azure Subscription to currently logged-in Account [Usage: `make get-az-subscription`]
	az \
		account \
			show \
				--output "$(AZ_OUTPUT)"

# see https://portal.azure.com/#view/Microsoft_Azure_Billing/SubscriptionsBlade
.SILENT .PHONY: set-az-subscription
set-az-subscription: # set Azure CLI Subscription to currently logged-in Account [Usage: `make set-az-subscription`]
	$(call print_arg,AZ_ACCOUNT_EMAIL,$(AZ_ACCOUNT_EMAIL))
	$(call print_arg,AZ_SUBSCRIPTION_ID,$(AZ_SUBSCRIPTION_ID))
	echo

	az \
		account \
			set \
				--output "$(AZ_OUTPUT)" \
				--subscription "$(AZ_SUBSCRIPTION_ID)"

# see https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure?tabs=bash#create-a-service-principal
.SILENT .PHONY: create-az-service-principal
create-az-service-principal: # create Azure Service Principal [Usage: `make create-az-service-principal`]
	$(call print_arg,AZ_SUBSCRIPTION_ID,$(AZ_SUBSCRIPTION_ID))

	$(call print_arg,AZ_SERVICEPRINCIPAL_NAME,$(AZ_SERVICEPRINCIPAL_NAME))

	$(call print_arg,AZ_SERVICEPRINCIPAL_ROLE,$(AZ_SERVICEPRINCIPAL_ROLE))
	echo

	az \
		ad \
			sp \
				create-for-rbac \
					--name "$(AZ_SERVICEPRINCIPAL_NAME)" \
					--output "$(AZ_OUTPUT)"
					# --role "$(AZ_SERVICEPRINCIPAL_ROLE)" \
					# --scopes "/subscriptions/$(AZ_SUBSCRIPTION_ID)" \


.SILENT .PHONY: list-az-locations
list-az-locations: # retrieve and format a list of available Azure Locations [Usage: `make list-az-locations`]
		az \
			account \
				list-locations \
					--output "$(AZ_OUTPUT)" \
					--query "[].{ displayName: displayName, name: name }"
