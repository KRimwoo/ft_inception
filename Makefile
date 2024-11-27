DOCKER_COMPOSE = docker-compose -f srcs/docker-compose.yml
INIT_SCRIPT = srcs/init.sh
ENV_FILE = srcs/.env

BASE_DIR = $(shell source $(ENV_FILE) && echo $$BASE_DIR)

all: init up

init:
	@bash $(INIT_SCRIPT)

up: init
	@$(DOCKER_COMPOSE) up -d --build

down:
	@$(DOCKER_COMPOSE) down -v

clean: down
	@docker system prune --all --force

fclean:
	@$(DOCKER_COMPOSE) down -v
	@docker system prune --all --volumes --force
	@docker network prune --force
	@sudo rm -rf $(BASE_DIR)

re: fclean all

.PHONY: all init up down clean fclean re
