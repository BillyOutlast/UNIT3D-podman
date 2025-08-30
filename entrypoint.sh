#!/bin/bash
chown -R unit3d:unit3d /var/www/html
cd /var/www/html
npm install
npm run build
su -s /bin/bash unit3d -c "/usr/bin/php -d variables_order=EGPCS /var/www/html/artisan serve --host=0.0.0.0 --port=8080"