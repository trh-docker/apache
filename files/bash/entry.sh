#!/usr/bin/dumb-init /bin/sh

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid

/usr/sbin/apache2 &

# Run PHP in background
/usr/sbin/php-fpm7.0 --nodaemonize --fpm-config /etc/php/7.0/fpm/php-fpm.conf 
