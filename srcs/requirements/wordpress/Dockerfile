FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y curl php php7.4-fpm php-mysql mariadb-client

COPY ./tools/wp_conf.sh ./wp_conf.sh

RUN chmod +x wp_conf.sh

# RUN         curl -sSL https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
#     -o /usr/local/bin/wait-for-it.sh && \
#     chmod +x /usr/local/bin/wait-for-it.sh

ENTRYPOINT ["./wp_conf.sh"]