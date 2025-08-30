# Installing Podman and Podman-Compose on Fedora

## 1. Update your system
```sh
sudo dnf update
```

## 2. Install Podman
```sh
sudo dnf install -y podman
```

## 3. Install Podman-Compose
```sh
sudo dnf install -y podman-compose
```

## 4. Verify Installation
```sh
podman --version
podman-compose --version
```

## 5. Add Remi's RPM Repository

```sh
sudo dnf install -y dnf-plugins-core
sudo dnf install -y https://rpms.remirepo.net/fedora/remi-release-$(rpm -E %fedora).rpm
sudo dnf module reset php -y
sudo dnf module enable php:remi-8.4 -y
```

## 6. Install PHP

```sh
sudo dnf install -y php
```

## 7. Install Additional PHP Extensions

```sh
sudo dnf install -y php-cli php-fpm php-json php-common php-mbstring php-xml php-gd php-curl php-zip php-mysqlnd
```

## 8. Start and Enable PHP-FPM

```sh
sudo systemctl start php-fpm
sudo systemctl enable php-fpm
```

## 9. Install Additional Packages

```sh
sudo dnf install -y php-bcmath php-intl php-redis mariadb
sudo dnf install -y unzip composer
```

## 10. Clone the UNIT3D Repository

Clone the UNIT3D repository from GitHub:

```sh
git clone https://github.com/HDInnovations/UNIT3D.git
cd UNIT3D
```

## 11. Copy the Environment File

After cloning the repository, copy the example environment file:

```sh
cp .env.example .env
```

## 12. Install Dependencies with Composer

Run the following commands inside the UNIT3D directory to install and update PHP dependencies:

```sh
composer update
composer install
```

## 13. Generate Application Key

Before generating the Laravel application key, ensure your `.env` file contains an `APP_KEY` variable (it can be empty):

```sh
php artisan key:generate
```

This command sets the `APP_KEY` value in your `.env` file, which is required for application security.

## 14. Run Database Migrations and Seed Data

To set up the database schema and seed initial data, run:

```sh
php artisan migrate:fresh --seed
```


## 15. Install Bun

If you want to use Bun for managing Node.js dependencies and building assets outside the Docker environment, install Bun globally:

```sh
curl -fsSL https://bun.sh/install | bash
```

After installation, restart your terminal or add Bun to your PATH as instructed by the installer.
p
## 16. Manage Node.js Dependencies and Compile Assets

To install Node.js dependencies and build frontend assets within the Docker environment, run:

```sh
bun install
bun pm untrusted
bun pm trust --all
bun install
bun run build
```

If you need to refresh the Node.js environment (for example, after updating dependencies), use:

```sh
rm -rf node_modules && bun pm cache rm && bun install && bun run build
```


## 17 Configure Unprivileged Ports

To allow non-root processes to bind to ports 80 and 443, add the following lines to `/etc/sysctl.conf`:

```
net.ipv4.ip_unprivileged_port_start=80
```

Apply the changes with:

```sh
sudo sysctl -p
```

## 178 Start the Application with Podman Compose

Navigate to the parent directory and start the containers using your environment file:

```sh
cd ..
podman-compose --env-file UNIT3D/.env up -d
```