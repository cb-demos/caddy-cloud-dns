.PHONY: help build test clean

help: ## Show this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

build: ## Build and push Docker image for multiple architectures
	@VERSION=$$(date +%Y.%m.%d); \
	echo "Building caddy-cloud-dns:$$VERSION for multiple architectures"; \
	docker buildx create --use --name caddy-multiarch-builder --driver docker-container --bootstrap 2>/dev/null || docker buildx use caddy-multiarch-builder; \
	docker buildx build --platform linux/amd64,linux/arm64 -t cloudbeesdemo/caddy-cloud-dns:$$VERSION -t cloudbeesdemo/caddy-cloud-dns:latest --push .

build-local: ## Build Docker image locally (current architecture only)
	@VERSION=$$(date +%Y.%m.%d); \
	echo "Building caddy-cloud-dns:$$VERSION locally"; \
	docker build -t cloudbeesdemo/caddy-cloud-dns:$$VERSION -t cloudbeesdemo/caddy-cloud-dns:latest .

test: ## Test the Docker image locally
	@echo "Testing caddy-cloud-dns image..."
	docker run --rm cloudbeesdemo/caddy-cloud-dns:latest caddy version
	@echo "✓ Caddy version check passed"
	docker run --rm cloudbeesdemo/caddy-cloud-dns:latest caddy list-modules | grep dns.providers.googleclouddns
	@echo "✓ Google Cloud DNS plugin loaded successfully"

clean: ## Clean up Docker build cache
	docker buildx prune -f