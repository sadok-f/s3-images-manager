FROM sadokf/php7-nginx-s6:7.2

MAINTAINER sadoknet@gmail.com

RUN \
  apt-get -y update && \
  apt-get -y install unixodbc-dev g++ zlib1g-dev libicu-dev libc-client-dev libkrb5-dev libxslt1-dev libpng-dev libmcrypt-dev

RUN docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr/
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl

RUN docker-php-ext-install pdo_odbc imap intl  xsl pdo gd

RUN pecl memcached install mcrypt sqlite3 redis intl

#install phpUnit & composer
RUN \
    wget "https://phar.phpunit.de/phpunit.phar" && \
    chmod +x phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini && \
    sed -i 's/memory_limit\s*=.*/memory_limit=1024M/g' /usr/local/etc/php/php.ini

#copy etc/
COPY docker/resources/etc/ /etc/
COPY .    /var/www/html


WORKDIR /var/www/html

RUN mkdir -p var/cache/ var/logs/ var/sessions/ web/uploads/.tmb && \
    chown -R www-data:www-data var/  web/uploads/ && \
    chmod 777 -R var/  web/uploads/


EXPOSE 80
