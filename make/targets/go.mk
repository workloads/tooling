# Go-specific Make Targets

BINARY_GO            ?= go
BINARY_GOCRITIC      ?= gocritic
BINARY_GOLANGCI_LINT ?= golangci-lint
BINARY_GORELEASER    ?= goreleaser
CONFIG_GO_MOD        ?= go.mod
INPUT_FILE           ?= ./main.go
OUTPUT_FILE           = dist/$(shell basename $(PWD))


.SILENT .PHONY: lint
lint: # lint codebase [Usage: `make lint`]
	$(call print_reference,$(shell pwd))

	$(BINARY_GO) \
		mod \
			tidy \
	&& \
	$(BINARY_GO) \
		fmt \
			./... \
	&& \
	$(BINARY_GO) \
		vet \
		./... \
	&& \
	$(BINARY_GOLANGCI_LINT) \
		run \
		./... \
	&& \
	$(BINARY_GOCRITIC) \
		check \
		./... \
	;

.SILENT .PHONY: test
test: # test Go code [Usage: `make test`]
	$(BINARY_GO) \
		test \
			-v ./... \
	;

.SILENT .PHONY: run
run: # run codebase [Usage: `make run command=<command>`]
	$(call print_reference,$(command))

	$(BINARY_GO) \
		run \
			$(INPUT_FILE) \
				$(command) \
	;

.SILENT .PHONY: build
build: # build Go code [Usage: `make build`]
	$(call print_reference,$(INPUT_FILE))

	$(BINARY_GO) \
		build \
			-o $(OUTPUT_FILE) \
			$(INPUT_FILE) \
	;

.SILENT .PHONY: snapshot
snapshot: # build snapshot using GoReleaser [Usage: `make snapshot`]
	$(BINARY_GORELEASER) \
		build \
			--clean \
			--single-target \
			--snapshot \
	;
