#!/bin/bash
echo "Updating DNF packages..."
sudo dnf -y update
echo "Setting up UNIT3D..."

sudo chown -R unit3d:unit3d /var/www/html /home/unit3d/

su -s /bin/bash unit3d -c "
cd /var/www/html
composer install --no-interaction --prefer-dist
mkdir -p \$HOME/.npm-packages
export NPM_PACKAGES=\"\$HOME/.npm-packages\"
export PATH=\"\$NPM_PACKAGES/bin:\$PATH\"
curl -fsSL https://bun.sh/install | bash
export BUN_INSTALL=\"\$HOME/.bun\"
export PATH=\"\$BUN_INSTALL/bin:\$PATH\"
bun install
bun pm untrusted
bun pm trust --all
bun install
bun run build

php artisan set:all_cache
php artisan queue:restart
php artisan scout:sync-index-settings
php artisan auto:sync_torrents_to_meilisearch --wipe && php artisan auto:sync_people_to_meilisearch
php -d variables_order=EGPCS /var/www/html/artisan serve --host=0.0.0.0 --port=8080
"