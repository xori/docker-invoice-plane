FROM ubuntu:14.04
MAINTAINER Evan Verworn <evan@verworn.ca>

RUN apt-get update && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y lamp-server^ php5-mcrypt unzip wget

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y pwgen python-setuptools
RUN easy_install supervisor
ADD ./start.sh /start.sh
ADD ./foreground.sh /etc/apache2/foreground.sh
ADD ./supervisord.conf /etc/supervisord.conf
RUN chmod 755 /start.sh
RUN chmod 755 /etc/apache2/foreground.sh

RUN echo "Fetching Invoice Plane" && \
	wget https://invoiceplane.com/download/v1.2.1 -O /tmp/invoice.zip
RUN echo "Unziping..." && \
	mkdir -p /var/www/html && \
	(cd /var/www/html && \
		unzip /tmp/invoice.zip && \
		chmod -R 755 .) && \
	rm /tmp/invoice.zip /var/www/html/index.html && \
	echo "We're live!"

ADD ./000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite && \
	php5enmod mcrypt && \
	chmod 777 /var/www/html/uploads /var/www/html/uploads/temp /var/www/html/application/config/database.php /var/www/html/application/helpers/mpdf/tmp /var/www/html/application/logs

VOLUME /var/lib/mysql

EXPOSE 80
CMD ["/bin/bash","/start.sh"]

