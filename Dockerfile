FROM php:7.3-alpine

LABEL maintainer="sam@samdjames.uk"

WORKDIR /application

RUN docker-php-ext-install pdo pdo_mysql
RUN apk add mysql-client
RUN curl -LO https://github.com/elgentos/masquerade/releases/latest/download/masquerade.phar
RUN chmod +x ./masquerade.phar && mv ./masquerade.phar /usr/bin/masquerade

ENTRYPOINT [ "/usr/bin/masquerade" ]
