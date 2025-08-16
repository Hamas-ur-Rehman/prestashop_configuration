#!/bin/bash
set -e

# Fix permissions again on startup (safety)
chown -R www-data:www-data /var/www/html
chmod -R 775 /var/www/html

# Ensure admin and install folders have proper write permissions
if [ -d "/var/www/html/admin" ]; then
    chmod -R 775 /var/www/html/admin
    chown -R www-data:www-data /var/www/html/admin
fi

if [ -d "/var/www/html/install" ]; then
    chmod -R 775 /var/www/html/install
    chown -R www-data:www-data /var/www/html/install
fi

ADMIN_PATH="/var/www/html/admin"
INSTALL_PATH="/var/www/html/install"

# Start background monitoring for admin folder rename
monitor_admin_rename() {
    echo "Starting background monitoring for admin folder rename..."
    while true; do
        if [ -d "$INSTALL_PATH" ]; then
            # Check if admin folder has been renamed (installation complete)
            if [ ! -d "$ADMIN_PATH" ] && ls /var/www/html/admin* > /dev/null 2>&1; then
                echo "$(date '+%Y-%m-%d %H:%M:%S') - Admin folder renamed detected - installation complete!"
                echo "$(date '+%Y-%m-%d %H:%M:%S') - Removing install folder for security..."
                rm -rf "$INSTALL_PATH"
                echo "$(date '+%Y-%m-%d %H:%M:%S') - Install folder removed successfully!"
                break
            else
                echo "$(date '+%Y-%m-%d %H:%M:%S') - Installation in progress - admin folder not renamed yet..."
            fi
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Install folder not found - monitoring stopped"
            break
        fi
        sleep 15
    done
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Admin folder monitoring finished"
}

# Start monitoring in background
monitor_admin_rename &

# Hand over to the original PrestaShop entrypoint and processes
exec "$@"
