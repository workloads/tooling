# OpenAPI-specific Make Targets

BINARY_REDOCLY ?= redocly
BINARY_SPECTRAL ?= spectral
CONFIG_REDOCLY ?= .redocly.yml
DECORATORS_REDOCLY_ARDUINO_RENDER ?= arduino-webserver-config/render-config
DECORATORS_REDOCLY_ARDUINO_REMOVE ?= arduino-webserver-config/remove-cruft
DECORATORS_REDOCLY_TERRAFORM_RENDER ?= tfplugingen-config/render-config
DECORATORS_REDOCLY_TERRAFORM_REMOVE ?= tfplugingen-config/remove-cruft
FORMAT_REDOCLY ?= stylish
INPUT_SPECTRAL ?= openapi.yml
OUTPUT_REDOCLY_HTML ?= dist/docs/index.html
OUTPUT_REDOCLY_ARDUINO ?= dist/routes.json
OUTPUT_REDOCLY_TERRAFORM ?= dist/generator_config.yml


.SILENT .PHONY: lint-redocly
lint-redocly: # lint OAS files using redocly [Usage: `make lint-redocly`]
	# see https://redocly.com/docs/cli/commands/lint
	$(BINARY_REDOCLY) \
		lint \
			--config="${CONFIG_REDOCLY}" \
			--format="${FORMAT_REDOCLY}" \
	;

.SILENT .PHONY: lint-redocly-config
lint-redocly-config: # lint Redocly config file using redocly [Usage: `make lint-redocly-config`]
	# see https://redocly.com/docs/cli/commands/check-config
	$(BINARY_REDOCLY) \
		check-config \
			--config="${CONFIG_REDOCLY}" \
			--lint-config="warn" \
	;

.SILENT .PHONY: lint-spectral
lint-spectral: # lint OAS files using spectral [Usage: `make lint-spectral`]
	# see https://redocly.com/docs/cli/commands/lint
	$(BINARY_SPECTRAL) \
		lint \
			$(INPUT_SPECTRAL) \
			--fail-severity=warn \
	;

.SILENT .PHONY: redocly-preview
redocly-preview: # preview docs using redocly [Usage: `make redocly-preview`]
	# see https://redocly.com/docs/cli/commands/preview-docs
	$(BINARY_REDOCLY) \
		preview-docs \
			--config="${CONFIG_REDOCLY}" \
			--skip-decorator="${DECORATORS_REDOCLY_TERRAFORM}" \
			--use-community-edition \
	;

.SILENT .PHONY: redocly-build
redocly-build: # build docs using redocly [Usage: `make redocly-build`]
	# see https://redocly.com/docs/cli/commands/build-docs
	# TODO: add support for per-API output directories once available
	$(BINARY_REDOCLY) \
		build-docs \
			--config="${CONFIG_REDOCLY}" \
			--disableGoogleFont=true \
			--output="${OUTPUT_REDOCLY_HTML}" \
	;

.SILENT .PHONY: redocly-bundle
redocly-bundle: # bundle output without decorators using redocly [Usage: `make redocly-bundle`]
	# see https://redocly.com/docs/cli/commands/bundle
	# TODO: add support for per-API output directories once available
	$(BINARY_REDOCLY) \
		--config="${CONFIG_REDOCLY}" \
		--output="${OUTPUT_REDOCLY_TERRAFORM}" \
		--skip-decorator="${DECORATORS_REDOCLY_ARDUINO},${DECORATORS_REDOCLY_TERRAFORM}" \
		bundle \
	;

.SILENT .PHONY: redocly-bundle-terraform
redocly-bundle-terraform: # bundle output for Terraform using redocly [Usage: `make redocly-bundle-terraform`]
	# see https://redocly.com/docs/cli/commands/bundle
	# TODO: add support for per-API output directories once available
	$(BINARY_REDOCLY) \
		--config="${CONFIG_REDOCLY}" \
		--output="${OUTPUT_REDOCLY_TERRAFORM}" \
		--skip-decorator="${DECORATORS_REDOCLY_ARDUINO_RENDER}" \
		--skip-decorator="${DECORATORS_REDOCLY_ARDUINO_REMOVE}" \
		bundle \
	;

.SILENT .PHONY: redocly-bundle-arduino
redocly-bundle-arduino: # bundle output for Arduino using redocly [Usage: `make redocly-bundle-arduino`]
	# see https://redocly.com/docs/cli/commands/bundle
	# TODO: add support for per-API output directories once available
	$(BINARY_REDOCLY) \
		--config="${CONFIG_REDOCLY}" \
		--output="${OUTPUT_REDOCLY_ARDUINO}" \
		--skip-decorator="${DECORATORS_REDOCLY_TERRAFORM_RENDER}" \
        --skip-decorator="${DECORATORS_REDOCLY_TERRAFORM_REMOVE}" \
		bundle \
	;

.SILENT .PHONY: redocly-generate-ignore
redocly-generate-ignore: # generate (or update) an ignores file using redocly [Usage: `make redocly-generate-ignore`]
	# see https://redocly.com/docs/cli/commands/lint
	$(BINARY_REDOCLY) \
		lint \
			--config="${CONFIG_REDOCLY}" \
			--format="${FORMAT_REDOCLY}" \
			--generate-ignore-file \
	;