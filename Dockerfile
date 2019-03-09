FROM quay.io/spivegin/tlmbasedebian


RUN apt-get update && apt-get install -y apache2 curl openssl gnupg wget gzip git &&\
	apt-get autoclean && apt-get autoremove &&\
	# rm -rf /etc/apache2/ &&\
	rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*


# ADD files/bash/entry.sh /opt/bin/
# ADD files/apache2 /etc/apache2
ENV APACHE_RUN_DIR=/var/run/apache2 \
	APACHE_RUN_USER=www-data \
	APACHE_RUN_GROUP=www-data \
	APACHE_PID_FILE=/var/run/apache2/apache2.pid \
	APACHE_RUN_DIR=/var/run/apache2 \
	APACHE_LOCK_DIR=/var/lock/apache2 \
	APACHE_LOG_DIR=/var/log/apache2 \
	LANG=C \
	APACHE_ULIMIT_MAX_FILES='ulimit -n 5120'

RUN mkdir -p /opt/bin /run/php/
WORKDIR /opt/tlm/html
# Setting up Caddy Server, AFZ Cert and installing dumb-init
ENV DINIT=1.2.2 \
	DOMAIN=0.0.0.0 \
	PORT=80 \
	PHP_VERSION=7.0

ADD https://raw.githubusercontent.com/adbegon/pub/master/AdfreeZoneSSL.crt /usr/local/share/ca-certificates/
ADD https://github.com/Yelp/dumb-init/releases/download/v${DINIT}/dumb-init_${DINIT}_amd64.deb /tmp/dumb-init_amd64.deb

RUN update-ca-certificates --verbose &&\
	dpkg -i /tmp/dumb-init_amd64.deb && \
	apt-get autoclean && apt-get autoremove &&\
	rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
RUN apt-get update && apt-get install -y \
	php${PHP_VERSION} \
	php${PHP_VERSION}.cgi \
	php${PHP_VERSION}-opcache \
	php${PHP_VERSION}-dom \
	php${PHP_VERSION}-ctype \
	php${PHP_VERSION}-curl \
	php${PHP_VERSION}-fpm \
	php${PHP_VERSION}-gd \
	php${PHP_VERSION}-intl \
	php${PHP_VERSION}-json \
	php${PHP_VERSION}-mbstring \
	php${PHP_VERSION}-mcrypt \
	php${PHP_VERSION}-mysqli \
	php${PHP_VERSION}-mysqlnd \
	php${PHP_VERSION}-opcache \
	php${PHP_VERSION}-pdo \
	php${PHP_VERSION}-posix \
	php${PHP_VERSION}-xml \
	php${PHP_VERSION}-iconv \
	php${PHP_VERSION}-imagick \
	php${PHP_VERSION}-xdebug \
	libapache2-mod-php${PHP_VERSION} \
	php-pear \
	php${PHP_VERSION}-phar && \
	apt-get autoclean && apt-get autoremove &&\
	rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
ADD files/php/ /etc/php/${PHP_VERSION}/fpm/pool.d/
ADD files/bash/entry.sh /opt/bin/
ADD files/bash/composer.sh /opt/
RUN chmod +x /opt/composer.sh && /opt/composer.sh &&\
	apt-get autoclean && apt-get autoremove &&\
	rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

RUN chmod +x /opt/bin/entry.sh && chown -R www-data:www-data /opt/tlm/html &&\
	rm -rf /var/www/html &&\
	ln -s /opt/tlm/html /var/www/ &&\
	a2enmod php${PHP_VERSION}
ADD files/html/index.html /opt/tlm/html/
EXPOSE 80

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/opt/bin/entry.sh"]