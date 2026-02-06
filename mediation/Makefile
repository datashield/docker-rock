#
# Docker helper
#

docker_compose_file=docker-compose.yml
no_cache=false
name=datashield/rock-mediation
tag=1.0.0

all:
	sudo docker build --no-cache=true -t="${name}:$(tag)-R$(r)" . && \
		sudo docker build -t="${name}:$(tag)" . && \
		sudo docker build -t="${name}:latest" . && \
		sudo docker image push ${name}:$(tag)-R$(r) && \
		sudo docker image push ${name}:$(tag) && \
		sudo docker image push ${name}:latest

# Build Docker image
build-image:
	docker build --no-cache=$(no_cache) -t="${name}:$(tag)" .

push-image:
	docker image push ${name}:$(tag)


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
