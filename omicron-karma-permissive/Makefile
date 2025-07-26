#
# Docker helper
#

docker_compose_file=docker-compose.yml
no_cache=true
name=datashield/rock-omicron-karma-permissive
tag=1.0.0

# Build Docker image
build-image:
	docker build --no-cache=$(no_cache) -t="${name}:$(tag)" .

push-image:
	docker image push ${name}:$(tag)

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

clean:
	rm -rf target
