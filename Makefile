all: flakes

target ?= flakes

flakes: ## build nix flake image
	@echo "build nix with nix"
	$(eval OUTPUT=$(shell sh -c "nix build --json --no-link --print-build-logs | jq -r \".[0].outputs.out\""))
	docker load < ${OUTPUT}
	docker run -it localhost/$(target)
