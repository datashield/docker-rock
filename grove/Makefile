# ---------------------------------------------------------------------------
# GLOBAL VARIABLES
# ---------------------------------------------------------------------------
docker_compose_file ?= docker-compose.yml
docker_compose_opal_file ?= docker-compose.opal-network.yml
name ?= datashield/rock-grove
tag ?= 0.0.0.9000

# Docker build configuration
no_cache ?= false
platform ?= linux/amd64

# Base Rock image
rock_base_image ?= datashield/rock-base:6.3.5-R4.6.1

# dsGeospatial version (release tag or commit SHA)
dsgeospatial_repo ?= FederatedMethods/dsGeospatial
dsgeospatial_ref ?= 642accd139054eb94d54bdca673957ae95689122

# ---------------------------------------------------------------------------
# DOCKER IMAGE
# ---------------------------------------------------------------------------
# Build Docker image
build-image:
	docker build \
		--platform $(platform) \
		--no-cache=$(no_cache) \
		--build-arg ROCK_BASE_IMAGE=$(rock_base_image) \
		--build-arg DSGEOSPATIAL_REPO=$(dsgeospatial_repo) \
		--build-arg DSGEOSPATIAL_REF=$(dsgeospatial_ref) \
		-t $(name):$(tag) .

# Push Docker image
push-image:
	docker image push $(name):$(tag)

# Build and push
publish: build-image push-image

# Remove local image
remove-image:
	docker image rm $(name):$(tag)

# ---------------------------------------------------------------------------
# DOCKER COMPOSE
# ---------------------------------------------------------------------------
config:
	docker compose -f $(docker_compose_file) config

up: config
	docker compose -f $(docker_compose_file) up -d --remove-orphans

down:
	docker compose -f $(docker_compose_file) down

stop:
	docker compose -f $(docker_compose_file) stop

start:
	docker compose -f $(docker_compose_file) start

restart:
	docker compose -f $(docker_compose_file) restart

pull:
	docker compose -f $(docker_compose_file) pull --include-deps

logs:
	docker compose -f $(docker_compose_file) logs -f

build:
	docker compose -f $(docker_compose_file) build --no-cache

# ---------------------------------------------------------------------------
# OPAL INTEGRATION (Opal already running as a container on the same Docker host)
# ---------------------------------------------------------------------------
# Attach the running grove container to Opal's network (auto-detected).
# Pass options with e.g.:  make connect-opal connect_args="--opal my-opal --network my_net"
connect_args ?=
connect-opal:
	bash scripts/connect-opal.sh $(connect_args)

# Detach it again
disconnect-opal:
	bash scripts/connect-opal.sh --remove --no-verify $(connect_args)

# Start grove already joined to Opal's network (requires OPAL_NETWORK in .env or the environment)
up-opal:
	docker compose -f $(docker_compose_file) -f $(docker_compose_opal_file) config > /dev/null
	docker compose -f $(docker_compose_file) -f $(docker_compose_opal_file) up -d --remove-orphans

# ---------------------------------------------------------------------------
# VALIDATION
# ---------------------------------------------------------------------------
check:
	docker run --rm $(name):$(tag) R -e "\
		stopifnot( \
			requireNamespace('dsBase', quietly = TRUE), \
			requireNamespace('dsTidyverse', quietly = TRUE), \
			requireNamespace('dsGeospatial', quietly = TRUE) \
		); \
		print(packageVersion('dsBase')); \
		print(packageVersion('dsTidyverse')); \
		print(packageVersion('dsGeospatial'))"

# ---------------------------------------------------------------------------
# CLEANUP
# ---------------------------------------------------------------------------
clean:
	rm -rf target

.PHONY: build-image push-image publish remove-image \
	config up down stop start restart pull logs build \
	connect-opal disconnect-opal up-opal check clean
