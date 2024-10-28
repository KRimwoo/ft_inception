DOCKER_COMPOSE = docker-compose -f srcs/docker-compose.yml
INIT_SCRIPT = srcs/init.sh

all: init up

init:
	@bash $(INIT_SCRIPT)

up: init
	@$(DOCKER_COMPOSE) up -d --build

down:
	@$(DOCKER_COMPOSE) down -v

clean: down
	@docker system prune --all --force

fclean: clean
	@docker system prune --volumes --force --all
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf ~/data/wordpress
	@sudo rm -rf ~/data/mariadb

re: fclean 
	@$(DOCKER_COMPOSE) up -d --build

.PHONY: all init up down clean fclean re
