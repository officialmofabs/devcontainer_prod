# README for Setting Up .env File for Docker Compose

This guide explains how to configure your environment variables using a `.env` file, removing the need for an installation script. You can now directly run your application with Docker Compose by setting the necessary values in the `.env` file.

## Prerequisites

- Docker and Docker Compose should be installed on your system.
- Your system should support Docker running with non-root user permissions (i.e., the user is part of the Docker group).

## Steps to Set Up the Environment

1. **Create an `.env` File**

   Create a `.env` file in the root directory of your project. This file will contain all the variables that Docker Compose will use during the build and runtime of the container.

   Example `.env` file:

   ```env
   # User ID (UID) of the current user
   USER_ID=1000
   
   # Group ID (GID) of the current user
   GROUP_ID=1000
   
   # Docker Group ID (GID) for Docker socket access
   DOCKER_GROUP_ID=999
   
   # Target directory for your application
   TARGET_DIR=/path/to/your/application
   
   # Python version to install (default: 3.11 if not set)
   PYTHON_VERSION=3.11
   
   # Container name, typically based on the target directory name
   CONTAINER_NAME=your_container_name
   
   # Timezone for the container (e.g., Asia/Ho_Chi_Minh)
   TZ=Asia/Ho_Chi_Minh
   ```

   - `USER_ID`: The UID of the user you want to run the container as (usually obtained via `id -u`).
   - `GROUP_ID`: The GID of the user you want to run the container as (usually obtained via `id -g`).
   - `DOCKER_GROUP_ID`: The GID of the Docker group to ensure proper access to Docker (you can obtain this with `getent group docker | cut -d ':' -f 3`).
   - `TARGET_DIR`: The target directory of your application where data will be mounted.
   - `PYTHON_VERSION`: The version of Python you want to install in your container. If left blank, it defaults to `3.11`.
   - `CONTAINER_NAME`: The name of the container, often derived from the target directory path.
   - `TZ`: The timezone for the container (e.g., `Asia/Ho_Chi_Minh`).


2. **Build and Run the Container with Docker Compose**

   Once the `.env` file is configured, you can build and run the container directly with Docker Compose:

   ```bash
   docker-compose up --build
   ```

   Docker Compose will use the environment variables from the `.env` file during the build and runtime.

## Additional Notes

- Ensure that the `TARGET_DIR` path is correct and accessible by Docker.
- You can adjust the `PYTHON_VERSION` to any version that is supported by the system. If you leave it blank, it will default to `3.11`.
- The `TZ` variable should be set to the appropriate timezone (e.g., `Asia/Ho_Chi_Minh`).

By using this method, you can easily modify the environment variables without needing to modify the script or Dockerfile directly. This also makes your Docker setup more portable and flexible for different environments.