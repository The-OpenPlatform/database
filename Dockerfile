FROM postgres:17

# Copy initialization script
COPY init.sql /docker-entrypoint-initdb.d/
