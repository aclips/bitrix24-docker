FROM zedsh/nginx

ARG APP_ENV='prod'
ARG APP_ENV=${APP_ENV}
ENV APP_ENV ${APP_ENV}

ARG USER_ID='1000'
ARG USER_ID=${USER_ID}
ENV USER_ID ${USER_ID}

ARG GROUP_ID='1000'
ARG GROUP_ID=${GROUP_ID}
ENV GROUP_ID ${GROUP_ID}

ARG PROJECT_PREFIX='web'
ARG PROJECT_PREFIX=${PROJECT_PREFIX}
ENV PROJECT_PREFIX=${PROJECT_PREFIX}



RUN apk --no-cache add shadow
RUN groupmod -g $USER_ID nginx
RUN usermod -u $USER_ID nginx

#
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf
RUN sed -i "s/#PROJECT_PREFIX#/${PROJECT_PREFIX}/g" /etc/nginx/conf.d/default.conf
COPY ./conf/upstream.conf /etc/nginx/conf.d/upstream.conf


EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
