FROM php:7.4-fpm

RUN apt update \
        && apt install -y \
            g++ \
            libicu-dev \
            libpq-dev \
            libzip-dev \
            zip \
            zlib1g-dev \
        && docker-php-ext-install \
            intl \
            opcache \
            pdo \
            pdo_pgsql \
            pgsql \
        && docker-php-ext-install \
            mysqli \
            pdo pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app
COPY composer.json .
RUN composer install --no-plugins --no-scripts
COPY . .
COPY .env.development .env

CMD php artisan key:generate && php artisan serve --host=0.0.0.0 --port=80