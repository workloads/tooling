# Hugo-specific Make Targets

BINARY_HUGO        ?= hugo
CONFIG_HUGO        ?= hugo.toml
CONFIG_HUGO_DEPLOY ?= hugo-deploy.toml
CLI_ARGS           ?= --config="$(CONFIG_HUGO)"
CLI_ARGS_DEPLOY    ?= --config="$(CONFIG_HUGO),$(CONFIG_HUGO_DEPLOY)"
DIR_DIST           ?= public


.SILENT .PHONY: build
build: # build website files [Usage: `make build`]
	$(BINARY_HUGO) \
		$(CLI_ARGS) \
	;

.SILENT .PHONY: config
config: # display configuration for website [Usage: `make config`]
	$(BINARY_HUGO) \
		config \
			$(CLI_ARGS) \
	;

.SILENT .PHONY: content
content: # create new content [Usage: `make content title="<title>"`]
	$(if $(title),,$(call missing_argument,title=<title>))

	$(BINARY_HUGO) \
		new \
			content \
				$(CLI_ARGS) \
				"$(DIR_CONTENT)/$(title).md" \
	;

.SILENT .PHONY: server
server: # start Hugo server [Usage: `make server`]
	$(BINARY_HUGO) \
		server \
			$(CLI_ARGS) \
			--baseURL="$(HUGO_BASEURL)" \
			--disableBrowserError \
			--disableFastRender \
			--forceSyncStatic \
			--gc \
			--navigateToChanged \
			--noBuildLock \
			--printUnusedTemplates \
			--tlsAuto \
	;

.SILENT .PHONY: deploy
deploy: # deploy new and updated content [Usage: `make deploy target="<target>"`]
	$(if $(target),,$(call missing_argument,target=<target>))

	$(BINARY_HUGO) \
		deploy \
  		$(CLI_ARGS_DEPLOY) \
  		--target="$(target)" \
	;

.SILENT .PHONY: trust
trust: # establish trust for generated TLS certificates [Usage: `make trust`]
	$(BINARY_HUGO) \
		server \
			trust \
			$(CLI_ARGS) \
	;
