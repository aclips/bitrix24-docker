FROM nginx:1.23.3-alpine-slim

ARG APP_ENV='prod'
ENV APP_ENV ${APP_ENV}

ARG USER_ID='1000'
ENV USER_ID ${USER_ID}

ARG GROUP_ID='1000'
ENV GROUP_ID ${GROUP_ID}

ARG PROJECT_PREFIX='project'
ENV PROJECT_PREFIX=${PROJECT_PREFIX}

RUN apk --no-cache add shadow \
	&& groupmod -g $USER_ID nginx \
	&& usermod -u $USER_ID nginx

COPY ["conf/nginx.conf", "conf/push_site.conf", "/etc/nginx/"]
COPY conf/conf.d/* /etc/nginx/conf.d/

RUN sed -i "s/#PROJECT_PREFIX#/${PROJECT_PREFIX}/g" /etc/nginx/conf.d/default.conf

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
