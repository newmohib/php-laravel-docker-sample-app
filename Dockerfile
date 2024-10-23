# Use the official PHP-FPM Alpine image
FROM php:8.2-fpm-alpine AS app

# Install Nginx and other dependencies
RUN apk update && apk add --no-cache nginx dos2unix

# Set the working directory
WORKDIR /var/www/html

# Copy Laravel app files to the container
COPY . /var/www/html



# Set permissions
# RUN chmod 755 /start.sh
RUN chown -R root:root /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage

RUN chown -R root:root /var/www/html
# RUN chmod -R 777 /var/www/html/storage
RUN chmod -R 775 /var/www/html/storage/framework/sessions/*

# Install Composer dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev --optimize-autoloader

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

# RUN chmod +x /start.sh
# RUN chmod 755 /start.sh

# # Start Nginx and PHP-FPM together using a custom entrypoint script
# ENTRYPOINT ["/start.sh"]

# Start PHP-FPM
# RUN php-fpm &
# # Start Nginx
# RUN nginx -g "daemon off;"

