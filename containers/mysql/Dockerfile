FROM mysql:5.7

ARG USER_ID='1000'
ARG USER_ID=${USER_ID}
ENV USER_ID ${USER_ID}

ARG GROUP_ID='1000'
ARG GROUP_ID=${GROUP_ID}
ENV GROUP_ID ${GROUP_ID}


ADD my.cnf /etc/mysql/conf.d/my.cnf

RUN groupmod -g $USER_ID mysql
RUN usermod -u $USER_ID mysql

CMD ["mysqld", "--character-set-server=utf8", "--collation-server=utf8_unicode_ci"]

EXPOSE 3306
