FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y

RUN apt-get install nginx openssl -y

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout \
    /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IleDeFrance/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}/UID=${ADMIN_NAME}"
# cree les certifcats ssl

COPY ./tools/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/wordpress

RUN chown -R www-data:www-data /var/www/wordpress

CMD ["nginx", "-g", "daemon off;"] 
#on lance nginx avec le daemon off pour qu'il reste au premier plan (sinon le container s'arrete) et avec CMD au lieu d'entrypoint pour toujours avoir la main dessus
