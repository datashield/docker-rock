#
# Docker helper
#

docker_compose_file=docker-compose.yml
no_cache=false
r=4.3

all:
	sudo docker build --no-cache=true -t="datashield/rock-base:$(tag)-R$(r)" . && \
		sudo docker build -t="datashield/rock-base:$(tag)" . && \
		sudo docker build -t="datashield/rock-base:latest" . && \
		sudo docker image push datashield/rock-base:$(tag)-R$(r) && \
		sudo docker image push datashield/rock-base:$(tag) && \
		sudo docker image push datashield/rock-base:latest

# Build Docker image
build-image:
	sudo docker build --no-cache=$(no_cache) -t="datashield/rock-base:$(tag)" .

push-image:
	sudo docker image push datashield/rock-base:$(tag)


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
