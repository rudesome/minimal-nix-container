all: flakes

target ?= flakes

flakes: ## build nix flake image
	@echo "build nix with nix"
	$(eval OUTPUT=$(shell sh -c "nix build --json --no-link --print-build-logs | jq -r \".[0].outputs.out\""))
	docker load < ${OUTPUT}
	docker run -it localhost/$(target)

.PHONY: help
help:  ## this help messages
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'
