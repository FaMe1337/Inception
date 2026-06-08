FROM debian:oldstable

RUN apt update && apt install -y nginx

COPY config/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]