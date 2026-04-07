.PHONY: build build-no-cache setup-buildx

IMAGE = ghcr.io/eliasmeireles/claude-container
PLATFORMS = linux/amd64,linux/arm64
VERSION_TAG = $(shell date +%Y%m%d)

setup-buildx:
	docker buildx create --use --name multiarch --driver docker-container 2>/dev/null || \
	docker buildx use multiarch

build: setup-buildx
	docker buildx build \
		--platform $(PLATFORMS) \
		--tag $(IMAGE):latest \
		--tag $(IMAGE):$(VERSION_TAG) \
		--file Dockerfile \
		--push \
		.
	@echo ""
	@echo "Pushed: $(IMAGE):latest"
	@echo "Pushed: $(IMAGE):$(VERSION_TAG)"

build-no-cache: setup-buildx
	docker buildx build \
		--no-cache \
		--platform $(PLATFORMS) \
		--tag $(IMAGE):latest \
		--tag $(IMAGE):$(VERSION_TAG) \
		--file Dockerfile \
		--push \
		.
	@echo ""
	@echo "Pushed: $(IMAGE):latest"
	@echo "Pushed: $(IMAGE):$(VERSION_TAG)"
