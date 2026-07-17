# User Documentation

This document explains how to use the Inception project after it has been cloned. It is intended for users or administrators who want to deploy, access and manage the application without modifying its source code.

---

# Services

The project consists of three Docker containers that work together to provide a complete WordPress website.

## NGINX

NGINX acts as the web server and reverse proxy.

It is responsible for:

- Accepting HTTPS connections.
- Serving static website files.
- Forwarding PHP requests to the WordPress container.

---

## WordPress

The WordPress container runs PHP-FPM and hosts the website.

It is responsible for:

- Executing the WordPress application.
- Managing pages, posts and media.
- Communicating with the MariaDB database.

---

## MariaDB

MariaDB stores all persistent website data.

This includes:

- Users
- Posts
- Pages
- Settings
- WordPress configuration

---

# Starting the Project

To build the Docker images and start all services, run:

```bash
make
```

or

```bash
make all
```

The project will automatically:

- Create the persistent data directories.
- Build the required Docker images.
- Start all containers.

---

# Stopping the Project

To stop and remove all running containers:

```bash
make stop
```

The persistent data stored on the host machine will not be removed.

---

# Restarting the Services

To restart all running containers:

```bash
make restart
```

---

# Accessing the Website

After the containers have started successfully, open your browser and navigate to:

```text
https://famendes.42.fr
```

If a different domain was configured in the `.env` file, use that domain instead.

---

# Accessing the WordPress Administration Panel

The WordPress dashboard is available at:

```text
https://famendes.42.fr/wp-admin
```

Log in using the administrator credentials stored inside the secrets directory.

---

# Credentials

Sensitive information is stored using Docker Secrets.

The secret files are located inside:

```text
secrets/
```

The project expects the following files:

```text
db_root_password.txt
db_password.txt
wp_admin_username.txt
wp_admin_password.txt
wp_admin_email.txt
wp_user_password.txt
```

These files contain the credentials used by the different services during initialization.

---

# Checking the Project Status

To verify that all services are running correctly:

```bash
make ps
```

You should see the three project containers in the **Up** state.

---

# Viewing Logs

To display and follow the logs of every service:

```bash
make logs
```

This command is useful when troubleshooting startup issues or checking the runtime status of the application.

---

# Accessing Containers

If you need to inspect one of the running containers, you can open an interactive shell.

## MariaDB

```bash
make dbshell
```

---

## WordPress

```bash
make wpshell
```

---

## NGINX

```bash
make nginxshell
```

---

# Docker Information

The following commands provide information about the Docker environment.

## Running Containers

```bash
make ps
```

---

## Docker Images

```bash
make images
```

---

## Docker Volumes

```bash
make volumes
```

---

## Docker Networks

```bash
make networks
```

---

# Cleaning the Project

To stop the project and remove all containers:

```bash
make stop
```

To remove unused Docker resources:

```bash
make clean
```

To completely reset the project, including persistent data stored on the host:

```bash
make fclean
```

To rebuild the entire project from scratch:

```bash
make re
```

---

# Troubleshooting

## The website cannot be reached

1. Verify that the containers are running:

```bash
make ps
```

2. Inspect the logs:

```bash
make logs
```

3. Make sure the project domain is correctly configured in your `/etc/hosts` file.

---

## Containers fail to start

Check the logs:

```bash
make logs
```

If necessary, rebuild the project:

```bash
make re
```

---

# Persistent Data

The project stores its persistent data inside:

```text
/home/<user>/data/
```

The directory contains:

```text
mariadb/
wordpress/
```

These directories ensure that the database and the WordPress files remain available even after the containers are stopped or recreated.