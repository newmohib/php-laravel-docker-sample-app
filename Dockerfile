# Use the official PHP-FPM Alpine image
FROM php:8.2-fpm-alpine AS app

# Install Nginx and other dependencies
RUN apk update && apk add --no-cache nginx dos2unix

# Set the working directory
WORKDIR /var/www/html

# Copy Laravel app files to the container
COPY . /var/www/html

# Set secure permissions
# Using www-data as the user/group for PHP-FPM and Nginx (default web user)
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Install Composer dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader \
    && chown -R www-data:www-data /var/www/html/vendor

# Nginx configuration
COPY ./nginx.conf /etc/nginx/nginx.conf


# Expose Nginx's HTTP port
EXPOSE 80

# Use CMD to start both services
CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]


# # Copy the start.sh script to the container
# COPY ./start.sh /start.sh

# # Fix potential line ending issues
# # RUN dos2unix /start.sh

# RUN chmod +x start.sh
# # RUN chmod 755 /start.sh

# # Start Nginx and PHP-FPM together using a custom entrypoint script
# geting error for alpine like // exec /start.sh: no such file or directory
# bash sh file can not run with alpine
# ENTRYPOINT ["/start.sh"]

