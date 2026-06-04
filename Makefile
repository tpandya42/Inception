ENV_FILE := srcs/.env
ifneq ("$(wildcard $(ENV_FILE))","")
include $(ENV_FILE)
export
endif
DATA_DIR ?= /home/$(USER)/data

all:
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress
	docker compose --env-file $(ENV_FILE) -f srcs/docker-compose.yml up --build -d

down:
	docker compose --env-file $(ENV_FILE) -f srcs/docker-compose.yml down

re: clean all

clean:
	docker compose --env-file $(ENV_FILE) -f srcs/docker-compose.yml down --rmi all -v

fclean: clean
	@sudo rm -rf $(DATA_DIR)/mariadb/*
	@sudo rm -rf $(DATA_DIR)/wordpress/*

.PHONY: all down re clean fclean
