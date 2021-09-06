FROM php:8.0.5-fpm-alpine

ARG PHPGROUP
ARG PHPUSER

ENV PHPGROUP=${PHPGROUP}
ENV PHPUSER=${PHPUSER}

RUN adduser -g ${PHPGROUP} -s /bin/sh -D ${PHPUSER}; exit 0

RUN mkdir -p /srv

WORKDIR /srv

RUN sed -i "s/user = www-data/user = ${PHPUSER}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = ${PHPGROUP}/g" /usr/local/etc/php-fpm.d/www.conf

RUN apk update && apk add --no-cache $PHPIZE_DEPS imagemagick-dev curl zip unzip libpq openssh libzip-dev\
    && docker-php-ext-install pdo_mysql mysqli pcntl zip\
    && pecl install xdebug imagick \
    && docker-php-ext-enable xdebug imagick

USER ${PHPUSER}
# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
