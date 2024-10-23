### Build and Run with Docker
-   docker compose build & docker compose up -d

### Run the Laravel applicaiton with MySQL DB contianer
- chmod +x script.sh && ./script.sh

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

#### Remove all container and image
- Remove all container
- docker container rm -f $( docker container ls -aq )
- Remove all image
- docker image rm -f $(docker image ls -q)


## geting error for alpine like // exec /start.sh: no such file or directory
## bash sh file can not run with alpine

#### Docs

- [dockerize-your-php-laravel-app-apache](https://medium.com/@aprilrieger/effortlessly-dockerize-your-php-laravel-app-a-step-by-step-guide-c1a6ffcc2b74)

- [dockerize-your-php-laravel-app-nginx](https://medium.com/@manuedavakandam/mastering-laravel-containerization-with-php-and-nginx-a-docker-a-docker-journey-d86ac9eed357)



- udo docker build -t my-laravel-app .
- docker run -d -p 8000:9000 --name my-laravel-container -e DB_DATABASE=testdb my-laravel-app
- /var/log/nginx/error.log or /var/log/php-fpm/error.log
