set -x && \
    # We don't need hirak/prestissimo since composer 2
    # if [ $(echo "${VERSION_PHP_MINOR} <= 7" | bc) -eq 1 ]; then \
    #     composer global require hirak/prestissimo ; \
    # fi && \
    if [ -f "/var/www/html/composer.lock" ]; then \
        if [ "${APP_ENV}" == "development" ] || [ "${APP_ENV}" == "dev" || "${APP_ENV}" == "staging" ] || [ "${APP_ENV}" == "stage" ]; then \
            composer install --working-dir=/var/www/html ; \
        else \
            composer install --no-dev --working-dir=/var/www/html ; \
        fi \
    fi && \
    # resolve: The stream or file "/var/www/html/storage/logs/laravel.log" could not be opened in append mode: failed to open stream: Permission denied
    touch /var/www/html/storage/logs/laravel.log && \
    touch /var/log/cron.log && \
    # please remove this APP_KEY generate for your production usage
    #   - ref: https://tighten.co/blog/app-key-and-you/
    php artisan key:generate && \
    chown -R www-data:www-data /var/www/html && \
    find /var/www/html/storage -type f -exec chmod 664 {} \; && \
    find /var/www/html/storage -type d -exec chmod 770 {} \;