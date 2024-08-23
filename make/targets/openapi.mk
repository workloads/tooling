# OpenAPI-specific Make Targets

BINARY_REDOCLY ?= redocly
BINARY_SPECTRAL ?= spectral
CONFIG_REDOCLY ?= redocly/config.yml
DECORATORS_REDOCLY ?= 'tfplugingen-config/render-config,tfplugingen-config/remove-cruft'
FORMAT_REDOCLY ?= stylish
INPUT_SPECTRAL ?= openapi.yml
OUTPUT_REDOCLY_HTML ?= dist/docs/index.html
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
redocly-preview: # preview Redocly docs using redocly [Usage: `make redocly-preview`]
	# see https://redocly.com/docs/cli/commands/preview-docs
	$(BINARY_REDOCLY) \
		preview-docs \
			--config="${CONFIG_REDOCLY}" \
			--skip-decorator="${DECORATORS_REDOCLY}" \
			--use-community-edition \
	;

.SILENT .PHONY: redocly-build
redocly-build: # build Redocly docs using redocly [Usage: `make redocly-build`]
	# see https://redocly.com/docs/cli/commands/build-docs
	# TODO: add support for per-API output directories once available
	$(BINARY_REDOCLY) \
		build-docs \
			--config="${CONFIG_REDOCLY}" \
			--disableGoogleFont \
			--output="${OUTPUT_REDOCLY_HTML}" \
	;

.SILENT .PHONY: redocly-bundle
redocly-bundle: # bundle Redocly package using redocly [Usage: `make redocly-bundle`]
	# see https://redocly.com/docs/cli/commands/bundle
	# TODO: add support for per-API output directories once available
	$(BINARY_REDOCLY) \
		--config="${CONFIG_REDOCLY}" \
		--output="${OUTPUT_REDOCLY_TERRAFORM}" \
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