# Use Bitnami PHP-FPM image
FROM bitnami/php-fpm:8.2 AS app

# Install Nginx and other dependencies
RUN install_packages nginx

# Set the working directory
WORKDIR /var/www/html

# Copy Laravel app files to the container
COPY . /var/www/html

# Set permissions
RUN chown -R root:root /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage

RUN chown -R root:root /var/www/html
RUN chmod -R 777 /var/www/html/storage

# Install Composer dependencies
RUN composer install --no-dev --optimize-autoloader

# Nginx configuration
COPY ./nginx.conf /etc/nginx/nginx.conf

# Expose Nginx's HTTP port
EXPOSE 80

# Start Nginx and PHP-FPM together using a custom entrypoint script
COPY ./start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]
