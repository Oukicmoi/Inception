WP_DATA	=	/home/gtraiman/data/wordpress
DB_DATA	=	/home/gtraiman/data/mariadb

all: up

up: build
	@mkdir -p ${WP_DATA}
	@mkdir -p ${DB_DATA}
	docker compose -f ./srcs/docker-compose.yml up -d

down:
	docker compose -f ./srcs/docker-compose.yml down

stop:
	docker compose -f ./srcs/docker-compose.yml stop

start:
	docker compose -f ./srcs/docker-compose.yml start

build:
	docker compose -f ./srcs/docker-compose.yml build

logs:
	docker compose -f ./srcs/docker-compose.yml logs

status:
	docker ps

clean:
	@docker stop $$(docker ps -qa) || true
	@docker rm $$(docker ps -qa) || true
	@docker rmi -f $$(docker images -qa) || true
	@docker volume rm $$(docker volume ls -q) || true
	@docker network rm $$(docker network ls -q) || true

re: clean up

prune: clean
	@docker system prune -a --volumes -f