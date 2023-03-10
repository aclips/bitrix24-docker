FROM gromdron/bitrix-push-workspace:v1.0

WORKDIR /opt/push-server

EXPOSE 9099

COPY push_config.toml .

ENV CONFIG_FILE=/opt/push-server/push_config.toml

STOPSIGNAL SIGKILL

CMD ["push-server"]
