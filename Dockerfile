FROM prestashop/prestashop:latest

# Copy custom entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/custom-entrypoint.sh

# Ensure script is executable
RUN chmod +x /usr/local/bin/custom-entrypoint.sh \
    && chown www-data:www-data /usr/local/bin/custom-entrypoint.sh

# Fix file ownership/permissions (this will be done again in entrypoint for safety)
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Use custom entrypoint that chains to original
ENTRYPOINT ["/usr/local/bin/custom-entrypoint.sh"]
CMD ["docker-php-entrypoint", "/tmp/docker_run.sh"]
