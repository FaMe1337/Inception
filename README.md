# Inception

## Description

This project aims to introduce the fundamentals of system administration through Docker containerization. Instead of installing multiple services directly on the host machine, each service runs inside its own isolated container while communicating through a dedicated Docker network.

The goal of this project is to deploy a fully functional WordPress website by orchestrating multiple Docker containers, each responsible for a single service.

The mandatory services are:

- **MariaDB** – Relational database used by WordPress.
- **WordPress + PHP-FPM** – Executes the PHP application and communicates with the database.
- **NGINX** – Handles HTTPS connections, serves static content and forwards PHP requests to PHP-FPM.

All services communicate through a private Docker network while using persistent Docker volumes to preserve data between container restarts.

---

# Installation

This section will guide through the complete installation of the this project, it assumes that you have zero knowledge of linux systems. But that you are using a computer, or Virtual Machine with either Debian or Ubuntu, and that you have the permissions to install software. For other distributions of Linux, you'll have to use their respective package managers (the programs that install other programs).

## Requirements

Before building the project, install the following software:

- Docker
- Docker Compose
- Git
- Make

If Git or Make are not installed:

```bash
sudo apt update
sudo apt install git make -y
```

Follow the official Docker installation guide for your Linux distribution.

Once Docker is installed, add your user to the Docker group:

```bash
sudo usermod -aG docker $USER
```

Reload your session:

```bash
newgrp docker
```

---

## Cloning the Repository

Clone the repository:

```bash
git clone <repository_url>
```

Move into the project directory:

```bash
cd Inception
```

---

# Project Configuration

## Environment Variables

The project uses a `.env` file to store **non-sensitive configuration values**.

Example:

```env
DOMAIN=famendes.42.fr

MYSQL_DATABASE=wordpress
MYSQL_USER=famendes

SITE_TITLE=Inception

MY_PATH=/srv/www
```

These variables configure the application and are safe to keep inside the repository.

---

## Docker Secrets

Sensitive information is stored separately using Docker Secrets.

Create a directory named:

```bash
mkdir secrets
```

Inside it, create the following files:

```text
db_root_password.txt
db_password.txt

wp_admin_username.txt
wp_admin_password.txt
wp_admin_email.txt

wp_user_password.txt
```

Populate each file with the corresponding value.

Example:

```text
db_root_password.txt
--------------------
my_root_password
```

These files are ignored by Git and mounted securely inside the containers during runtime.

---

## Domain Configuration

Add the following entry to your host machine:

```bash
sudo sh -c 'echo "127.0.0.1 famendes.42.fr" >> /etc/hosts'
```

If you changed the value of `DOMAIN` inside the `.env` file, update the command accordingly.

---

# Running the Project

Build and start all services:

```bash
make
```

or directly with Docker Compose:

```bash
docker compose up --build
```

Once all containers are running, the website will be available at:

```text
https://famendes.42.fr
```

---

# Project Overview

## Virtual Machines vs Docker

Virtual machines emulate an entire operating system, including their own kernel, making them heavier in terms of storage and memory usage.

Docker containers share the host kernel while keeping applications isolated from one another. This results in significantly lower resource consumption and much faster startup times, making containers ideal for service-oriented architectures like this project.

---

## Environment Variables vs Docker Secrets

Although both provide configuration values to containers, they serve different purposes.

### Environment Variables

Environment variables are intended for non-sensitive configuration values, such as:

- Domain name
- Database name
- Website title
- File paths

### Docker Secrets

Docker Secrets are designed to securely store confidential information, including:

- Database passwords
- MariaDB root password
- WordPress administrator credentials

Keeping secrets separate from the source code prevents sensitive information from being committed to version control.

---

## Docker Networks

The containers communicate through a dedicated Docker bridge network.

This allows services to reach each other using their service names instead of IP addresses.

```
          HTTPS
             │
             ▼
         NGINX
             │
             ▼
   WordPress + PHP-FPM
             │
             ▼
          MariaDB
```

Using a private network improves isolation while allowing the services to communicate internally.

---

## Docker Volumes

Persistent storage is provided using Docker volumes.

The project uses two volumes:

- **MariaDB volume** – Stores all database files.
- **WordPress volume** – Stores the WordPress installation and website content.

Both volumes are mapped inside:

```text
/home/<login>/data
```

This ensures that neither the database nor the website files are lost after restarting or rebuilding the containers.

---

## HTTPS

NGINX is configured to serve the website exclusively through HTTPS using **TLS 1.2** and **TLS 1.3**.

A self-signed SSL certificate is generated during the image build process and installed automatically inside the NGINX container.

NGINX serves static content directly while forwarding all PHP requests to the PHP-FPM container.