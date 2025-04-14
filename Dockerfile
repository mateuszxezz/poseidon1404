FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim unzip git curl \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libpq-dev \                      # <- Adiciona isso
    && docker-php-ext-install pdo pdo_pgsql \  # <- E isso
    && docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . .

RUN composer install --optimize-autoloader --no-dev

COPY .docker/render-nginx/default.conf /etc/nginx/conf.d/default.conf

RUN chown -R www-data:www-data /var/www

CMD php artisan serve --host=0.0.0.0 --port=8080