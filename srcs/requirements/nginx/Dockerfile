FROM	debian:bookworm-slim

RUN		apt-get update && apt-get upgrade -y && apt-get install -y nginx openssl \
		 && rm -rf /var/lib/apt/lists/*

COPY 	./conf/default.conf /etc/nginx/nginx.conf
COPY 	./tools/script.sh ./script.sh
RUN 	chmod +x ./script.sh

EXPOSE 443

# rm -rf /var... thingy removes the cached package index files that apt-get downloads
ENTRYPOINT [ "./script.sh", "sh" ]
