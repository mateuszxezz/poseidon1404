FROM php:8.2-fpm

# Instala dependências
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
    && docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Cria diretório do app
WORKDIR /var/www

COPY . .

RUN composer install --optimize-autoloader --no-dev

COPY .docker/render-nginx/default.conf /etc/nginx/conf.d/default.conf

# Dá permissão
RUN chown -R www-data:www-data /var/www

CMD php artisan migrate --force && php-fpm
