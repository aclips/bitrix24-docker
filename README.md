# docker-bitrix24

Набор __docker__ контейнеров и утилит для работы с __bitrix24__.

## Getting started

### 1. Клонирование репозитория в директорию с проектами

```bash
$ cd ~/projects
$ git clone https://github.com/aclips/bitrix24-docker

# Переименование директории проекта
$ mv ./bitrix24-docker project_name
```

### 2. Настройка

#### 2.1 .env файл

При первом запуске сборки будет создан файл переменных окружения ```.env``` на базе файла ```.env.example```.
Файл ```.env.example``` нужно изменить в соответствии с проектом, над которым будет вестись разработка.

```
PROJECT_PREFIX=poject_name
APP_ENV=test
HTTP_PORT=80

# MySQL settings
MYSQL_HOST=mysql
MYSQL_DATABASE=db_name
MYSQL_USER=db_user
MYSQL_PASSWORD=db_password
```

#### 2.2 docker-compose.yml

Для удобства, в файле __docker-compose.yml__ в контейнере nginx можно указать alias для адреса проекта

```yaml
services:
  nginx:
    ...
    networks:
      default:
        aliases:
          - project.localhost
```

### 3. Запуск контейнеров

Вместо стандартного запуска контейнеров через ```docker-compose up``` можно исполнять файл ```up.sh```

```bash
$ sudo ./up.sh
```

После успешного запуска по адресу __project.localhost__, указанному в *[пт 2.2] docker-compose.yml*, будет отображаться 
содержимое директории *./www*

> Перед запуском нужно убедиться что выключены другие контейнеры и службы, слушающие порт 80

![](./src/example.mp4)

### 4. Остановка контейнеров

Для остановки контейнеров можно выполнить файл ```down.sh```.

```bash
$ sudo ./up.sh
```

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
