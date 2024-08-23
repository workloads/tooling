# OpenAPI-specific Make Targets

# see https://docs.stoplight.io/docs/spectral/9ffa04e052cc1-spectral-cli

BINARY_REDOCLY ?= redocly
BINARY_SPECTRAL ?= spectral
CONFIG_REDOCLY ?= redocly/config.yml
FORMAT_REDOCLY ?= stylish
INPUT_SPECTRAL ?= openapi.yml

.SILENT .PHONY: lint-redocly
lint-redocly: # lint OAS files using redocly [Usage: `make lint-redocly`]
	$(BINARY_REDOCLY) \
		lint \
			--config="${CONFIG_REDOCLY}" \
			--format="${FORMAT_REDOCLY}" \
	;

.SILENT .PHONY: lint-redocly-config
lint-redocly-config: # lint Redocly config file using redocly [Usage: `make lint-redocly-config`]
	$(BINARY_REDOCLY) \
		check-config \
			--config="${CONFIG_REDOCLY}" \
			--lint-config="error" \
	;

.SILENT .PHONY: lint-spectral
lint-spectral: # lint OAS files using spectral [Usage: `make lint-spectral`]
	# see https://redocly.com/docs/cli/commands/lint
	$(BINARY_SPECTRAL) \
		lint \
		$(INPUT_SPECTRAL) \
	;

.SILENT .PHONY: redocly-preview
redocly-preview: # preview Redocly docs using redocly [Usage: `make redocly-preview`]
	# see https://redocly.com/docs/cli/commands/preview-docs
	$(BINARY_REDOCLY) \
		preview-docs \
			--use-community-edition \
	;

.SILENT .PHONY: redocly-build
redocly-build: # build Redocly docs using redocly [Usage: `make redocly-build`]
	# see https://redocly.com/docs/cli/commands/build-docs
	# TODO: add support for per-API output directories once available
	$(BINARY_REDOCLY) \
		build-docs \
	;

.SILENT .PHONY: redocly-generate-ignore
redocly-generate-ignore: # generate (or update) an ignores file using redocly [Usage: `make redocly-generate-ignore`]
	$(BINARY_REDOCLY) \
		lint \
			--config="${CONFIG_REDOCLY}" \
			--format="${FORMAT_REDOCLY}" \
			--generate-ignore-file \
	;