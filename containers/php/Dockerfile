FROM phpdockerio/php:7.4-fpm
 
RUN mkdir -p /var/run/mysqld
RUN mkdir -p /run/php
 
ARG APP_ENV='prod'
ARG APP_ENV=${APP_ENV}
ENV APP_ENV ${APP_ENV}
 
ARG USER_ID='1000'
ARG USER_ID=${USER_ID}
ENV USER_ID ${USER_ID}
 
ARG GROUP_ID='1000'
ARG GROUP_ID=${GROUP_ID}
ENV GROUP_ID ${GROUP_ID}
 
ARG PROJECT_PREFIX='develop'
ARG PROJECT_PREFIX=${PROJECT_PREFIX}
ENV PROJECT_PREFIX=${PROJECT_PREFIX}
 
 
 
 
RUN echo `test ${APP_ENV} '=' 'local' &&  echo "${APP_ENV} php-xdebug on" || echo "${APP_ENV} php-xdebug off"`
 
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
    php7.4-memcached \
    php7.4-memcache \
    php7.4-mysql \
    php-xdebug \
    php7.4-intl \
    php7.4-interbase \
    php7.4-opcache \
    php7.4-gd \
    php7.4-imagick \
    php7.4-zip \
    php7.4-soap \
    php7.4-ldap \
    ssmtp \
    wget \
    bash \
    rsync \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
 
 
ADD ./conf/php.ini /etc/php/7.4/fpm/php.ini
ADD ./conf/php.ini /etc/php/7.4/cli/php.ini
ADD ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i -e "s/www-data:x:33:33:www-data:\/var\/www:\/usr\/sbin\/nologin/www-data:x:${USER_ID}:${GROUP_ID}:www-data:\/var\/www\/html:\/bin\/bash/g" /etc/passwd
RUN sed -i -e "s/www-data:x:33:/www-data:x:${GROUP_ID}:/g" /etc/group
RUN chmod a+w /etc/ImageMagick-6/policy.xml
RUN sed -i -e 's/coder" rights="none" pattern="PDF/coder" rights="read|write" pattern="PDF/g' /etc/ImageMagick-6/policy.xml
#RUN rm -f /etc/php/7.4/fpm/pool.d/z-overrides.conf
RUN cd /bin && curl --silent --show-error https://getcomposer.org/installer | php && mv composer.phar composer && chmod 777 composer
RUN ln -f -s /usr/bin/php7.4 /etc/alternatives/php
WORKDIR /home/bitrix/www
EXPOSE 9000
