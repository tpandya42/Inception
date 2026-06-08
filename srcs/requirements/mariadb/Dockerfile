FROM	debian:bookworm

RUN		apt-get update && apt-get upgrade -y \
		&& apt-get install -y mariadb-server vim \
		&& rm -rf /var/lib/apt/lists/*

# creating directory with appropriate rights and ownership
RUN mkdir -p /var/run/mysqld \
&& chown -R mysql:mysql /var/run/mysqld \
&& chmod 777 /var/run/mysqld

# default mariadb port
EXPOSE 3306

COPY  ./conf/mysqld.conf /etc/mysql/mariadb.conf.d/60-inception.cnf
COPY ./tools/script.sh /usr/local/bin/script.sh
#COPY ./conf/sqlScript.sql /usr/local/bin/

RUN chmod +x /usr/local/bin/script.sh
#RUN chmod +x /usr/local/bin/sqlScript.sql

VOLUME [ "/var/lib/mysql" ]

ENTRYPOINT [ "/usr/local/bin/script.sh" ]

#to enable mariadb to listen globally
CMD ["mariadbd","--user=mysql", "--datadir=/var/lib/mysql"]
