FROM debian:oldstable

RUN apt update && apt install -y nginx openssl gettext-base && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl /etc/nginx/templates && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=PT/ST=Lisboa/L=Lisboa/O=42/OU=Inception/CN=famendes.42.fr" \
    -addext "subjectAltName=DNS:famendes.42.fr"

COPY config/nginx.conf /etc/nginx/templates/nginx.conf.template

EXPOSE 443

COPY tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

ENTRYPOINT [ "/usr/local/bin/setup.sh" ]