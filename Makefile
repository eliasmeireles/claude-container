.PHONY: build build-amd64 build-arm64 build-no-cache setup-buildx

IMAGE = ghcr.io/eliasmeireles/claude-container
VERSION_TAG = $(shell date +%Y%m%d)

setup-buildx:
	docker buildx create --use --name multiarch --driver docker-container 2>/dev/null || \
	docker buildx use multiarch

build-amd64: setup-buildx
	docker buildx build \
		--platform linux/amd64 \
		--tag $(IMAGE):latest-amd64 \
		--tag $(IMAGE):$(VERSION_TAG)-amd64 \
		--file Dockerfile \
		--push \
		.
	@echo ""
	@echo "Pushed: $(IMAGE):latest-amd64"
	@echo "Pushed: $(IMAGE):$(VERSION_TAG)-amd64"

build-arm64: setup-buildx
	docker buildx build \
		--platform linux/arm64 \
		--tag $(IMAGE):latest-arm64 \
		--tag $(IMAGE):$(VERSION_TAG)-arm64 \
		--file Dockerfile \
		--push \
		.
	@echo ""
	@echo "Pushed: $(IMAGE):latest-arm64"
	@echo "Pushed: $(IMAGE):$(VERSION_TAG)-arm64"

build: build-amd64 build-arm64

build-no-cache: setup-buildx
	docker buildx build \
		--no-cache \
		--platform linux/amd64 \
		--tag $(IMAGE):latest-amd64 \
		--tag $(IMAGE):$(VERSION_TAG)-amd64 \
		--file Dockerfile \
		--push \
		.
	docker buildx build \
		--no-cache \
		--platform linux/arm64 \
		--tag $(IMAGE):latest-arm64 \
		--tag $(IMAGE):$(VERSION_TAG)-arm64 \
		--file Dockerfile \
		--push \
		.
	@echo ""
	@echo "Pushed: $(IMAGE):latest-amd64"
	@echo "Pushed: $(IMAGE):latest-arm64"
