#!/bin/bash

IMAGE_NAME="custom_laravel_nginx"  # Name for the custom Docker image
BACKUP_IMAGE_NAME="${IMAGE_NAME}_backup_$(date +%Y%m%d%H%M%S)"  # Backup image name with timestamp
CONTAINER_NAME="laravel_container_nginx"  # Name for the running Laravel container

# Execute permissions on the start script

chmod +x start.sh

# Function to stop and remove the Docker container if it exists
function stop_and_remove_container() {
    if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
        echo "Stopping and removing the existing container: $CONTAINER_NAME..."
        docker stop $CONTAINER_NAME
        docker rm $CONTAINER_NAME
        echo "Container $CONTAINER_NAME has been stopped and removed."
    else
        echo "No existing container named $CONTAINER_NAME found."
    fi
}

# Function to backup and remove the Docker image if it exists
function backup_and_remove_docker_image() {
    if docker image inspect $IMAGE_NAME > /dev/null 2>&1; then
        echo "Docker image $IMAGE_NAME already exists. Creating a backup..."
        docker tag $IMAGE_NAME $BACKUP_IMAGE_NAME
        echo "Backup created as $BACKUP_IMAGE_NAME"

        # Now remove the original image
        echo "Removing the original Docker image: $IMAGE_NAME..."
        docker rmi $IMAGE_NAME
        echo "Docker image $IMAGE_NAME has been removed."
    else
        echo "No existing Docker image named $IMAGE_NAME found. Proceeding without backup."
    fi
}

# Function to run the backup image if the new build fails
function run_backup_image() {
    echo "Attempting to run the backup image..."
    if docker image inspect $BACKUP_IMAGE_NAME > /dev/null 2>&1; then
        # Start the container using the backup image
        echo "Starting container with backup image: $BACKUP_IMAGE_NAME..."
        docker run -d --name $CONTAINER_NAME $BACKUP_IMAGE_NAME
        echo "Container is running with backup image."
    else
        echo "Backup image $BACKUP_IMAGE_NAME does not exist. Unable to revert."
    fi
}

# Check if the "src" folder is empty or not

# if [ ! -d "./src" ]; then
#     echo "The src directory does not exist. Cloning a fresh Laravel project..."
#     git clone https://github.com/laravel/laravel.git ./src
# elif [ ! "$(ls -A ./src)" ]; then
#     echo "The src directory is empty. Cloning a fresh Laravel project..."
#     git clone https://github.com/laravel/laravel.git ./src
# else
#     echo "Laravel source already exists in ./src"
# fi


# Stop and remove the existing container, if any
stop_and_remove_container

# Backup the existing Docker image, then remove it
backup_and_remove_docker_image

# Build the Docker image
echo "Building the custom Laravel Docker image..."
if docker-compose build; then
    echo "Build succeeded as new Image: $IMAGE_NAME. Starting the containers..."
    docker-compose up -d
else
    echo "Build failed. Reverting to the backup image..."
    # Run the backup image if the build failed
    run_backup_image
fi
