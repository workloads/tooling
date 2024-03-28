# Azure CLI-specific Make Targets

# set sensible defaults for Azure Service Principal configuration
AZ_SERVICEPRINCIPAL_NAME ?= "terraform-$(RANDOM_STRING)"
AZ_SERVICEPRINCIPAL_ROLE ?= "Contributor"

# retrieve Account Email from currently authenticated Azure Account
AZ_ACCOUNT_EMAIL   ?= $(shell $(BINARY_AZ) account show --output "$(FORMAT_AZ)" --query 'user.name')

# format Azure Locations output to be a list of names, ignoring any items that contain the strings `stage` or `uap`
AZ_LOCATIONS_QUERY ?= [?!(contains(name, 'stage') || contains(name, 'uap'))].{ name: name, regionalDisplayName: regionalDisplayName }
AZ_LOCATIONS_FILE  ?= "variables_azure_locations.json"

# retrieve Subscription ID from currently authenticated Azure Account, using Account Email
AZ_SUBSCRIPTION_ID ?= $(shell $(BINARY_AZ) account list --output "$(FORMAT_AZ)" --query "[?user.name == '$(AZ_ACCOUNT_EMAIL)']|[0].id")

# logic to enable update for Terraform-loaded variable file with Azure Locations
UPDATE_TOGGLE =

ifdef update_file
	UPDATE_TOGGLE = > "variables_azure_locations.json"
endif

# see https://portal.azure.com/#view/Microsoft_Azure_Billing/SubscriptionsBlade
.SILENT .PHONY: get-az-subscription
get-az-subscription: # get Azure Subscription to currently logged-in Account [Usage: `make get-az-subscription`]
	$(BINARY_AZ) \
		account \
			show \
				--output "$(FORMAT_AZ)"

# see https://portal.azure.com/#view/Microsoft_Azure_Billing/SubscriptionsBlade
.SILENT .PHONY: set-az-subscription
set-az-subscription: # set Azure CLI Subscription to currently logged-in Account [Usage: `make set-az-subscription`]
	$(call print_arg,AZ_ACCOUNT_EMAIL,$(AZ_ACCOUNT_EMAIL))
	$(call print_arg,AZ_SUBSCRIPTION_ID,$(AZ_SUBSCRIPTION_ID))
	echo

	$(BINARY_AZ) \
		account \
			set \
				--output "$(FORMAT_AZ)" \
				--subscription "$(AZ_SUBSCRIPTION_ID)"

# see https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure?tabs=bash#create-a-service-principal
.SILENT .PHONY: create-az-service-principal
create-az-service-principal: # create Azure Service Principal [Usage: `make create-az-service-principal`]
	$(call print_arg,AZ_SUBSCRIPTION_ID,$(AZ_SUBSCRIPTION_ID))

	$(call print_arg,AZ_SERVICEPRINCIPAL_NAME,$(AZ_SERVICEPRINCIPAL_NAME))

	$(call print_arg,AZ_SERVICEPRINCIPAL_ROLE,$(AZ_SERVICEPRINCIPAL_ROLE))
	echo

	$(BINARY_AZ) \
		ad \
			sp \
				create-for-rbac \
					--name "$(AZ_SERVICEPRINCIPAL_NAME)" \
					--output "$(FORMAT_AZ)"
					# --role "$(AZ_SERVICEPRINCIPAL_ROLE)" \
					# --scopes "/subscriptions/$(AZ_SUBSCRIPTION_ID)" \

.SILENT .PHONY: list-az-locations
list-az-locations: # retrieve and format a list of available Azure Locations [Usage: `make list-az-locations update_file=true`]
		$(BINARY_AZ) \
			account \
				list-locations \
					--output "$(FORMAT_AZ)" \
					--query "$(AZ_LOCATIONS_QUERY)" \
					$(UPDATE_TOGGLE)
