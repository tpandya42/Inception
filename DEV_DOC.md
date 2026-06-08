# Developer Documentation

This document describes how a developer can set up and work with the Inception project.

## Environment Setup

### Prerequisites

-   Docker and Docker Compose must be installed on your system.
-   The project must be run on a Virtual Machine.
-   You must have `make` installed.

### Configuration

1.  **Clone the repository.**
2.  **Set up the `.env` file:** Navigate to the `srcs` directory and copy the `env.example` file to a new file named `.env`.
    ```bash
    cp srcs/env.example srcs/.env
    ```
3.  **Edit the `.env` file:** Open `srcs/.env` and fill in the required values for the domain name, database user, passwords, etc.
4.  **Edit your hosts file:** To make the domain name point to your local IP, you need to add an entry to your `/etc/hosts` file.
    ```
    127.0.0.1 <your-domain-name>.42.fr
    ```
    Replace `<your-domain-name>` with the one you configured in your `.env` file.

### Secrets

The subject strongly recommends using Docker Secrets to manage sensitive information. This project is missing the `secrets` directory. To implement it, you should:

1.  Create a `secrets` directory at the root of the project.
2.  Create files within the `secrets` directory to hold your passwords (e.g., `db_password.txt`).
3.  Update the `docker-compose.yml` file to use these secrets.
4.  Ensure the `secrets` directory is added to your `.gitignore` file.

## Building and Running the Project

-   To **build and launch** the project, run the following command from the root of the project:
    ```bash
    make
    ```
    This command will use Docker Compose to build the images and start the containers.

## Managing Containers and Volumes

-   **List running containers:**
    ```bash
    docker-compose -f srcs/docker-compose.yml ps
    ```
-   **View logs for a specific service:**
    ```bash
    docker-compose -f srcs/docker-compose.yml logs <service_name>
    ```
    (e.g., `nginx`, `wordpress`, `mariadb`)
-   **Stop and remove containers:**
    ```bash
    make down
    ```
-   **Remove volumes:** To completely remove all data, you can use the `down` command in the `Makefile` with the `v` option:
    ```bash
    make fclean
    ```

## Data Persistence

-   The WordPress database files are stored in a Docker volume named `mariadb_data`.
-   The WordPress website files are stored in a Docker volume named `wordpress_data`.

The data for these volumes is located in `/home/<user>/data` on the host machine, where `<user>` is your login. On macOS, this path is `/Users/<user>/data`.
