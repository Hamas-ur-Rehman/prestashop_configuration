FROM prestashop/prestashop:latest

# Copy custom entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/custom-entrypoint.sh

# Ensure script is executable
RUN chmod +x /usr/local/bin/custom-entrypoint.sh \
    && chown www-data:www-data /usr/local/bin/custom-entrypoint.sh

# Set PHP configuration environment variables
ENV PHP_INI_MEMORY_LIMIT="512M" \
    PHP_INI_MAX_EXECUTION_TIME="600" \
    PHP_INI_UPLOAD_MAX_FILESIZE="20M" \
    PHP_INI_POST_MAX_SIZE="22M"

# Create custom PHP configuration
RUN echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/custom.ini && \
    echo "max_execution_time = 600" >> /usr/local/etc/php/conf.d/custom.ini && \
    echo "upload_max_filesize = 20M" >> /usr/local/etc/php/conf.d/custom.ini && \
    echo "post_max_size = 22M" >> /usr/local/etc/php/conf.d/custom.ini

# Fix file ownership/permissions (this will be done again in entrypoint for safety)
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html


# Use custom entrypoint that chains to original
ENTRYPOINT ["/usr/local/bin/custom-entrypoint.sh"]
CMD ["docker-php-entrypoint", "/tmp/docker_run.sh"]
