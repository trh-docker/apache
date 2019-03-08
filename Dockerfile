FROM quay.io/spivegin/php7

RUN apt-get update && apt-get install -y apache2 &&\
	apt-get autoclean && apt-get autoremove &&\
	rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
	
ADD files/bash/entry.sh /opt/bin/
ADD files/apache2 /etc/
ENV APACHE_RUN_DIR=/var/run/apache2
RUN chmod +x /opt/bin/entry.sh && chown -R www-data:www-data /opt/tlm/html && mkdir /var/run/apache2
EXPOSE 80

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/opt/bin/entry.sh"]