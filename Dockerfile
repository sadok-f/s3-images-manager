FROM php:7-fpm

MAINTAINER sadoknet@gmail.com

RUN \
  apt-get -y update && \
  apt-get -y install \
  curl vim wget git build-essential make gcc nasm mlocate \
  nginx supervisor \
  net-tools

RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.org.list && \
    echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.org.list && \
    wget -O- http://www.dotdeb.org/dotdeb.gpg | apt-key add -

#PHP7 dependencies
RUN apt-get -y update && \
    apt-get -y install \
    php7.0-mysql php7.0-odbc \
    php7.0-curl php7.0-gd \
    php7.0-intl php-pear \
    php7.0-imap php7.0-mcrypt \
    php7.0-pspell php7.0-recode \
    php7.0-sqlite3 php7.0-tidy \
    php7.0-xmlrpc php7.0-xsl \
    php7.0-xdebug php7.0-redis \
    php-gettext && \
    docker-php-ext-install pdo pdo_mysql opcache


RUN \
    echo "extension=/usr/lib/php/20151012/redis.so" > /usr/local/etc/php/conf.d/redis.ini && \
    echo "extension=/usr/lib/php/20151012/intl.so" > /usr/local/etc/php/conf.d/intl.ini && \
    echo "extension=/usr/lib/php/20151012/gd.so" > /usr/local/etc/php/conf.d/gd.ini && \
    echo "zend_extension=/usr/lib/php/20151012/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini


#install phpUnit & composer
RUN \
    wget "https://phar.phpunit.de/phpunit.phar" && \
    chmod +x phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#copy etc/
COPY docker/resources/etc/ /etc/
COPY .    /var/www/html


WORKDIR /var/www/html

RUN mkdir -p var/cache/ var/logs/ var/sessions/ && \
    chown -R www-data:www-data var/


EXPOSE 80

CMD ["/usr/bin/supervisord"]