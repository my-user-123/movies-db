# Dockerfile

FROM mysql:8.0

ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=streaming

# Allow local infile
CMD ["mysqld", "--local-infile=1"]

# Copy init script
COPY init.sql /docker-entrypoint-initdb.d/

# Copy data CSV files to mysql‑files directory
COPY data/*.csv /var/lib/mysql-files/
