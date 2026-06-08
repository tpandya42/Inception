# User Documentation

This document explains how an end user or administrator can use the Inception project.

## Services

The project provides the following services:

-   **A WordPress website:** A personal website accessible via a web browser.
-   **NGINX:** A web server that routes traffic to the WordPress site.
-   **MariaDB:** A database that stores the WordPress site's data.

## Getting Started

### Starting and Stopping the Project

-   To **start** the project, navigate to the root directory of the project and run the following command:
    ```bash
    make
    ```
-   To **stop** the project, run the following command:
    ```bash
    make down
    ```

### Accessing the Website and Admin Panel

-   **Website:** The WordPress website can be accessed by navigating to `https://<your-domain-name>.42.fr` in your web browser. Replace `<your-domain-name>` with the domain you configured in the `.env` file.
-   **Administration Panel:** The WordPress administration panel can be accessed at `https://<your-domain-name>.42.fr/wp-admin`.

### Managing Credentials

The credentials for the WordPress users and the database are stored in the `srcs/.env` file. You can manage them by editing this file. **Remember to not use "admin" or "administrator" as a username for the administrator account.**

### Checking Services

To check if the services are running correctly, you can use the following command:

```bash
docker-compose -f srcs/docker-compose.yml ps
```

This will show the status of all the containers.
