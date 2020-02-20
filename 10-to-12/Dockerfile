FROM postgres:12

RUN sed -i 's/$/ 10/' /etc/apt/sources.list.d/pgdg.list

RUN apt-get update && apt-get install -y --no-install-recommends \
		postgresql-10=10.12-1.pgdg100+1 \
	&& rm -rf /var/lib/apt/lists/*

ENV INSTALL_USER=""

ENV PGBINOLD /usr/lib/postgresql/10/bin
ENV PGBINNEW /usr/lib/postgresql/12/bin

ENV PGDATAOLD /var/lib/postgresql/10/data
ENV PGDATANEW /var/lib/postgresql/12/data

RUN mkdir -p "$PGDATAOLD" "$PGDATANEW" \
	&& chown -R postgres:postgres /var/lib/postgresql

WORKDIR /var/lib/postgresql

COPY ./entrypoint.sh /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]