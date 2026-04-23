all:
	# @mkdir -p $(DATA_PATH)/mariadb
	# @mkdir -p $(DATA_PATH)/wordpress
	docker compose -f srcs/docker-compose.yml up --build -d

down:
	docker compose -f srcs/docker-compose.yml down

re: clean all

clean:
	docker compose -f srcs/docker-compose.yml down --rmi all -v

fclean: clean
	@sudo rm -rf /home/tpandya/data/mariadb/*
	@sudo rm -rf /home/tpandya/data/wordpress/*

.PHONY: all down re clean fclean
