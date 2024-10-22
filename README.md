### Build and Run with Docker

-   docker compose build & docker compose up -d

## Install Dependencies

-   sudo apt-get update && sudo apt-get upgrade
-   sudo apt-get install software-properties-common
-   sudo add-apt-repository ppa:ondrej/php
-   sudo apt-get update
-   sudo apt-get install php8.2

### install for laravel

-   suto apt-get install docker
-   suto apt-get install composer
-   suto apt-get install php@8.2
-   composer global require laravel/installer

#### Create Your New PHP Laravel Project

-   composer create-project --prefer-dist laravel/laravel laravel-app

#### Start the Apache Server

-   cd laravel-app
-   php artisan serve

-   Now, you can visit http://localhost:8000/ in your browser.
