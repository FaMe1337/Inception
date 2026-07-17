# Developer Documentation

This document describes how to configure, build and maintain the Inception project. It is intended for developers who want to modify the project or understand how it is organized.

---

# Project Overview

The project deploys a complete WordPress stack using Docker Compose.

Each service is isolated inside its own container:

- **NGINX** – HTTPS reverse proxy.
- **WordPress** – PHP-FPM application.
- **MariaDB** – Relational database.

The containers communicate through a dedicated Docker bridge network while sharing persistent storage through Docker volumes.

---

# Prerequisites

Before building the project, install the following software:

- Docker
- Docker Compose
- GNU Make
- Git

Docker should be configured so that commands can be executed without using `sudo`.

---

# Project Structure

```
.
├── Makefile
├── secrets/
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   └── requirements/
│       ├── mariadb/
│       │   ├── Dockerfile
│       │   ├── conf/
│       │   └── tools/
│       ├── nginx/
│       │   ├── Dockerfile
│       │   ├── conf/
│       │   └── tools/
│       └── wordpress/
│           ├── Dockerfile
│           ├── conf/
│           └── tools/
└── README.md
```

### Makefile

Provides a simplified interface for building, launching and managing the project.

### docker-compose.yml

Defines the project services, Docker network, volumes, secrets and container configuration.

### requirements/

Contains the source code for each service.

Each service has:

- Dockerfile
- configuration files
- initialization scripts

---

# Environment Configuration

General configuration values are stored inside:

```
srcs/.env
```

Typical variables include:

- DOMAIN
- MYSQL_DATABASE
- MYSQL_USER
- SITE_TITLE
- MY_PATH

These variables configure the application but do not contain confidential information.

---

# Docker Secrets

Sensitive information is stored separately using Docker Secrets.

The project expects the following files:

```
secrets/

db_root_password.txt
db_password.txt
wp_admin_username.txt
wp_admin_password.txt
wp_admin_email.txt
wp_user_password.txt
```

These files are mounted inside the containers during startup and are never committed to the repository.

---

# Building the Project

Build and launch every service:

```bash
make
```

or

```bash
make all
```

Docker Compose will automatically:

- build the images
- create the network
- create the volumes
- start every container

---

# Docker Compose

The project uses Docker Compose to orchestrate all services.

The compose file defines:

- services
- bridge network
- persistent volumes
- Docker Secrets
- restart policy

Each service is built from its own Dockerfile located inside the `requirements` directory.

---

# Makefile Commands

## Start the project

```bash
make
```

---

## Restart containers

```bash
make restart
```

---

## Stop containers

```bash
make stop
```

---

## Follow logs

```bash
make logs
```

---

## Show running containers

```bash
make ps
```

---

## Build individual services

MariaDB

```bash
make build-db
```

WordPress

```bash
make build-wp
```

NGINX

```bash
make build-nginx
```

---

## Rebuild without cache

MariaDB

```bash
make rebuild-db
```

WordPress

```bash
make rebuild-wp
```

NGINX

```bash
make rebuild-nginx
```

---

## Open interactive shells

MariaDB

```bash
make dbshell
```

WordPress

```bash
make wpshell
```

NGINX

```bash
make nginxshell
```

---

# Docker Resources

Display running containers:

```bash
make ps
```

Display Docker images:

```bash
make images
```

Display Docker volumes:

```bash
make volumes
```

Display Docker networks:

```bash
make networks
```

---

# Persistent Storage

Persistent data is stored outside the containers.

Host directory:

```
/home/<user>/data/
```

Contents:

```
mariadb/
wordpress/
```

The MariaDB volume stores the database files.

The WordPress volume stores the website files.

Because these directories are located on the host machine, data remains available after containers are restarted or recreated.

---

# Development Workflow

A typical development workflow is:

1. Modify the source code or configuration.
2. Rebuild the affected service.
3. Restart the project.
4. Verify the logs.

Example:

```bash
make rebuild-nginx
make restart
```

or

```bash
make rebuild-wp
make restart
```

If persistent data must also be removed:

```bash
make re
```

---

# Cleaning the Project

Stop the project:

```bash
make stop
```

Remove unused Docker resources:

```bash
make clean
```

Completely reset the project:

```bash
make fclean
```

Rebuild everything from scratch:

```bash
make re
```

---

# Troubleshooting

If a service fails to start:

1. Check the logs.

```bash
make logs
```

2. Verify that all containers are running.

```bash
make ps
```

3. Verify that Docker volumes and secrets exist.

```bash
make volumes
```

4. Rebuild the affected service.

```bash
make rebuild-<service>
```

5. If necessary, recreate the entire project.

```bash
make re
```