#
# Docker helper
#

docker_compose_file=docker-compose.yml
no_cache=false
r=4.4

all:
	docker build --no-cache=true -t="datashield/rock-base:$(tag)-R$(r)" . && \
		docker build -t="datashield/rock-base:$(tag)" . && \
		docker build -t="datashield/rock-base:latest" . && \
		docker image push datashield/rock-base:$(tag)-R$(r) && \
		docker image push datashield/rock-base:$(tag) && \
		docker image push datashield/rock-base:latest

# Build Docker image
build-image:
	docker build --no-cache=$(no_cache) -t="datashield/rock-base:$(tag)" .

# Build the native executable variant
build-image-native:
	docker build --no-cache=$(no_cache) --build-arg VARIANT=-native -t="datashield/rock-base:$(tag)-native" .

push-image:
	docker image push datashield/rock-base:$(tag)


up:
	docker-compose -f $(docker_compose_file) up -d --remove-orphans

down:
	docker-compose -f $(docker_compose_file) down

stop:
	docker-compose -f $(docker_compose_file) stop

start:
	docker-compose -f $(docker_compose_file) start

restart:
	docker-compose -f $(docker_compose_file) restart

pull:
	docker-compose -f $(docker_compose_file) pull --include-deps

logs:
	docker-compose -f $(docker_compose_file) logs -f

build:
	docker-compose -f $(docker_compose_file) build --no-cache

clean:
	rm -rf target
