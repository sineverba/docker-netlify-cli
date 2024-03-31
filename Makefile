IMAGE_NAME=sineverba/netlify-cli
CONTAINER_NAME=netlify-cli
APP_VERSION=1.0.1-dev
NODE_VERSION=20.12.0
NPM_VERSION=10.5.0
NETLIFY_CLI_VERSION=17.21.1
NETLIFY_SITE_ID=a1b2c3
BUILDX_VERSION=0.13.1


build:
	docker build \
		--build-arg NODE_VERSION=$(NODE_VERSION) \
		--build-arg NPM_VERSION=$(NPM_VERSION) \
		--build-arg NETLIFY_CLI_VERSION=$(NETLIFY_CLI_VERSION) \
		--tag $(IMAGE_NAME):$(APP_VERSION) \
		"."

preparemulti:
	mkdir -vp ~/.docker/cli-plugins
	curl \
		-L \
		"https://github.com/docker/buildx/releases/download/v$(BUILDX_VERSION)/buildx-v$(BUILDX_VERSION).linux-amd64" \
		> \
		~/.docker/cli-plugins/docker-buildx
	chmod a+x ~/.docker/cli-plugins/docker-buildx
	docker buildx version
	docker buildx ls
	docker buildx create --name multiarch --use
	docker buildx inspect --bootstrap --builder multiarch

multi: 
	docker buildx build \
		--build-arg NODE_VERSION=$(NODE_VERSION) \
		--build-arg NPM_VERSION=$(NPM_VERSION) \
		--build-arg NETLIFY_CLI_VERSION=$(NETLIFY_CLI_VERSION) \
		--platform linux/arm64/v8,linux/amd64,linux/arm/v6,linux/arm/v7 \
		--tag $(IMAGE_NAME):$(APP_VERSION) \
		"."

test:
	docker run --rm -it $(IMAGE_NAME):$(APP_VERSION) cat /etc/os-release | grep "Alpine Linux v3.19"
	docker run --rm -it $(IMAGE_NAME):$(APP_VERSION) cat /etc/os-release | grep "VERSION_ID=3.19.1"
	docker run --rm -it $(IMAGE_NAME):$(APP_VERSION) node -v | grep $(NODE_VERSION)
	docker run --rm -it $(IMAGE_NAME):$(APP_VERSION) npm -v | grep $(NPM_VERSION)
	docker run --rm -it $(IMAGE_NAME):$(APP_VERSION) netlify -v | grep $(NETLIFY_CLI_VERSION)

initnetlify:
	docker run \
		--rm \
		-it \
		-v $(PWD)/dist:/app \
		$(IMAGE_NAME):$(APP_VERSION) \
		netlify \
		deploy \
		--auth $(NETLIFY_AUTH_TOKEN)

deploynetlify:
	docker run \
		--rm \
		-it \
		-v $(PWD)/dist:/app/dist \
		$(IMAGE_NAME):$(APP_VERSION) \
		netlify \
		deploy -s $(NETLIFY_SITE_ID) \
		--auth $(NETLIFY_AUTH_TOKEN) \
		--prod \
		--dir ./dist

inspect:
	docker run \
		--rm \
		-it \
		--entrypoint /bin/sh \
		-v $(PWD)/dist:/app/dist \
		$(IMAGE_NAME):$(APP_VERSION) \
		

destroy:
	-docker image rm node:$(NODE_VERSION)-alpine3.19
	-docker image rm $(IMAGE_NAME):$(APP_VERSION)