FROM quay.io/spivegin/php7

RUN apt-get update && apt-get install -y apache2 &&\
	apt-get autoclean && apt-get autoremove &&\
	rm -rf /etc/apache2/ &&\
	rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
	
ADD files/bash/entry.sh /opt/bin/
ADD files/apache2 /etc/apache2
ENV APACHE_RUN_DIR=/var/run/apache2 \
	APACHE_RUN_USER=www-data \
	APACHE_RUN_GROUP=www-data \
	APACHE_PID_FILE=/var/run/apache2/apache2.pid \
	APACHE_RUN_DIR=/var/run/apache2 \
	APACHE_LOCK_DIR=/var/lock/apache2 \
	APACHE_LOG_DIR=/var/log/apache2 \
	LANG=C \
	APACHE_ULIMIT_MAX_FILES='ulimit -n 65536'

RUN chmod +x /opt/bin/entry.sh && chown -R www-data:www-data /opt/tlm/html && mkdir /var/run/apache2  &&\
	ln -s /opt/tlm/html /var/www/html 
	# ln -s /etc/apache2/mods-enabled  /opt/tlm/html/mods-enabled &&\
	# ln -s /etc/apache2/ports.conf  /opt/tlm/html/ports.conf &&\
EXPOSE 80

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/opt/bin/entry.sh"]