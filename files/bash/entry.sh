#!/usr/bin/dumb-init /bin/sh

# Run PHP in background
/usr/sbin/php-fpm7.0 --nodaemonize --fpm-config /etc/php/7.0/fpm/php-fpm.conf &
# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid
chmod +x /etc/apache2/envvars 
./etc/apache2/envvars
/usr/sbin/apache2