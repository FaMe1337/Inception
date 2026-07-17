VOLUMES_PATH = /home/${USER}/data

DB_PATH = ${VOLUMES_PATH}/mariadb
WP_PATH = ${VOLUMES_PATH}/wordpress

COMPOSE = docker compose -f srcs/docker-compose.yml

all:
	mkdir -p ${DB_PATH} ${WP_PATH}
	${COMPOSE} up --build -d

restart:
	${COMPOSE} restart

logs:
	${COMPOSE} logs -f

ps:
	${COMPOSE} ps

images:
	docker images

volumes:
	docker volume ls

networks:
	docker network ls

dbshell:
	docker exec -it mariadb bash

wpshell:
	docker exec -it wp-php bash

nginxshell:
	docker exec -it nginx bash

build-db:
	${COMPOSE} build database

build-wp:
	${COMPOSE} build wordpress

build-nginx:
	${COMPOSE} build nginx

rebuild-nginx:
	${COMPOSE} build nginx --no-cache

rebuild-wp:
	${COMPOSE} build wordpress --no-cache

rebuild-db:
	${COMPOSE} build database --no-cache

clean: stop
	docker system prune -a --force

fclean: clean
	sudo rm -rf ${VOLUMES_PATH}

re: fclean all

buildmariadb:
	docker build srcs/requirements/mariadb -t mariadb

runmariadb: buildmariadb
	mkdir -p ${DB_PATH} ${WP_PATH}
	docker run mariadb

stop:
	${COMPOSE} down

help:
	@echo "Available targets:"
	@echo "  make               Build and start the stack"
	@echo "  make restart       Restart the containers"
	@echo "  make stop          Stop and remove the stack"
	@echo "  make clean         Stop the stack and prune Docker data"
	@echo "  make fclean        Remove persistent data under /home/$$USER/data"
	@echo "  make re            Full reset and relaunch"
	@echo "  make ps            Show Compose container status"
	@echo "  make images        Show Docker images"
	@echo "  make volumes       Show Docker volumes"
	@echo "  make networks      Show Docker networks"
	@echo "  make logs          Show and follow logs for all services"
	@echo "  make dbshell       Open a shell in the MariaDB container"
	@echo "  make wpshell       Open a shell in the WordPress container"
	@echo "  make nginxshell    Open a shell in the NGINX container"
	@echo "  make build-db      Build the database service"
	@echo "  make build-wp      Build the WordPress service"
	@echo "  make build-nginx   Build the NGINX service"
	@echo "  make rebuild-db    Rebuild the database service without cache"
	@echo "  make rebuild-wp    Rebuild the WordPress service without cache"
	@echo "  make rebuild-nginx Rebuild the NGINX service without cache"

.PHONY: all restart logs ps images volumes networks dbshell wpshell nginxshell build-db build-wp build-nginx rebuild-db rebuild-wp rebuild-nginx clean fclean re buildmariadb runmariadb stop help