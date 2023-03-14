# docker-bitrix24

Набор __docker__ контейнеров и утилит для работы с __bitrix24__.

## Getting started

### 1. Клонирование репозитория в директорию с проектами

```bash
$ cd ~/projects
$ git clone https://github.com/aclips/bitrix24-docker

# Переименование директории проекта
$ mv ./docker-bitrix24 project_name

# Альтернативный вариант (чтобы не делать каждый раз git clone):
$ cp -R ./docker-bitrix24 project_name
```

### 2. Настройка

После копирования проекта дополнительно нужно сконфигурировать: `.env`-файл проекта и настройки push-сервера.

#### 2.1 .env файл

Перед стартом проекта необходимо выполнить команду `./dctl.sh make:env`, который создаст `.env`-файл по шаблону.
Можно не пользоваться этой утилитой, а вручную скопировать `.env.example` в `.env` и отредактировать его

#### 2.2 push-сервер

Для того чтобы подключить в своем проекте локальный push-сервер на технологии websocket при развороте сконифгурировать необходимые параметры в конфигурационном файле.
Конфигурационный файл находится в `./containers/push/push_config.toml`.

Нужно сконфигурировать `security`-раздел:
Либо __выключить__ проверку подписи (`enabled = false`)
Либо в `key` задать ключ, который в последствии будет использоваться в настройка модуля "Push'n'pull" Битрикс24.
Дополнительные настройки см в п.7 инструкции.

https://github.com/gromdron/bitrix-push-workspace

### 3. Запуск контейнеров

Для запуска сборки необходимо использовать один из следующих вариантов запуска:

Вместо стандартного запуска контейнеров через ```docker-compose up``` можно исполнять файл ```up.sh```

```bash
$ sudo ./up.sh
```

Альтернативный вариант: использовать команду `sudo ./dctl.sh up silent`

После успешного запуска по адресу __project.localhost__, указанному в *[пт 2.2] docker-compose.yml*, будет отображаться 
содержимое директории *./www*

> Перед запуском нужно убедиться что выключены другие контейнеры и службы, слушающие порт 80

![](./src/example.mp4)

### 4. Остановка контейнеров

Для остановки контейнеров можно выполнить файл ```down.sh```.

```bash
$ sudo ./down.sh
```
Альтернативный вариант: использовать команду `sudo ./dctl.sh down`


### 5. Контроллер dctl.sh
__dctl.sh__ - скрипт предоставляющий доступ к часто используемым сценариям.

#### 5.1 Список команд

```
make env - copy .env.example to .env
make db - load init bitrix database dump to mysql
db import FILE - load FILE to mysql
db renew - load dump from repo, fresh db and apply
db - run db cli
db export > file.sql - export db to file
build - make docker build
up - docker up in console
up silent - docker up daemon
down - docker down
run - run in php container from project root
test - run tests
cli some_command - run scripts/cli.php some_command (migration, etc)
cept some_command (cept generate:cept acceptance Test) - run codeception with params
```

### 6. Проблемы совместимости

> При использовании продукции от Apple на M1 Chip __mysql:5.7__ нужно заменить на __mariadb:10.5__
>
> __Файл__ *./containers/mysql/Dockerfile* FROM mysql:5.7 > FROM mariadb:10.5

### 7. Настройки push-сервера

После запуска проекта необходимо закончить настройку push-сервера.

`На сервер установлена:   Виртуальная машина 7.3 и новее (Bitrix Push server 2.0) `
`Путь для публикации команд: http://push:9099/bitrix/pub/`
`Код-подпись для взаимодействия с сервером: <из push_config.toml>`

>В случае если в `push_config.toml` в разделе `[security]` указано `enabled = false` то не важно что указано к "код-подпись" - все равно не проверяется.
