# docker-bitrix24

Набор __docker__ контейнеров и утилит для работы с __bitrix24__.

## Getting started

### 1. Клонирование репозитория в директорию с проектами

```bash
$ cd ~/projects
$ git clone https://github.com/aclips/bitrix24-docker

# Переименование директории проекта
$ mv ./bitrix24-docker project_name

# Альтернативный вариант (чтобы не делать каждый раз git clone):
$ cp -R ./bitrix24-docker project_name
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

### 8. Настройки Xdebug

Перед запуском проекта необходимо выполнить настройку PHPStorm.

#### 8.1 Установка плагинов

В настройках PHPStorm (File -> Settings) перейти в раздел Plugins. Проверить, что плагины `Docker` и `PHP Docker`
установлены и активированы.

#### 8.2 Добавление Docker сервера

В настройках PHPStorm перейти в раздел Build, Execution, Deployment -> Docker. Добавить
подключение к Docker нажав `+`. Оставить настройки по умолчанию.

#### 8.3 Добавление внешнего интерпретатора

В настройках перейти в раздел PHP, нажать `...` справа от настройки CLI Interpreter. В открывшемся окне CLI
Interpreters нажать `+`, (выбрать `From Docker, Vagrant...`). В разделе `Lifecycle` выбрать
пункт `Connect to existing container`. Сохранить и выбрать созданный интерпретатор.

#### 8.4 Добавление PHP сервера

В настройках перейти в раздел PHP -> Servers, нажать `+` для добавления сервера. В настройках сервера указать
хост `127.0.0.1`, порт `80`. Выбрать пункт `Use path mappings`, установить соответствие папок `www`
и `/home/bitrix/www`. После создания сервера открыть `docker-compose.yml`. заменить serverName в
строке `PHP_IDE_CONFIG: serverName=serverName` на имя созданного сервера.

#### 8.5 Настройка Xdebug.

В настройках перейти в раздел PHP -> Debug. Во вкладке Xdebug указать порт `9001`.

#### 8.6 Добавление конфигурации.

В настройках конфигураций (Run -> Edit configurations) нажать `+`. В открывшемся списке выбрать `PHP Remote Debug`.
Отметить пункт `Filter debug connection by IDE key`. При создании конфигурации выбрать ранее созданный
сервер (п. 3), в поле `IDE key` указать `PHPSTORM`.

#### 8.7 Установка расширения

Установить
расширение ([пример для Firefox](https://addons.mozilla.org/ru/firefox/addon/xdebug-helper-for-firefox/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)).
Перейти в настройки расширения, в разделе `IDE key` выбрать `PHPSTORM`. Включить расширение.

#### 8.8 Отладка

В правом верхнем углу запустить прослушивание (Start listening for PHP Debug Connections), расставить брейкпоинты,
открыть страницу в браузере.

#### 8.9 Проблемы совместимости

> При установленном PHP версии меньше 8.0 заменить `xdebug` в Dockerfile на `xdebug-3.1.6`.

> Посмотреть ошибки подключения можно вызвав функцию `xdebug_info()`.

> Если после выполнения всех пунктов дебаг не работает, возможно Firewall блокирует соединение. В таком случае, можно открыть порт (`sudo ufw allow 9001` в Ubuntu).