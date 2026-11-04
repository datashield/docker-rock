# ---------------------------------------------------------------------------
# GLOBAL VARIABLES
# ---------------------------------------------------------------------------
docker_compose_file ?= docker-compose.yml
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
up:
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
	up down stop start restart pull logs build check clean
