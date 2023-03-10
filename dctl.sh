#!/bin/bash
set -e
#first cd current dir
cd "$(dirname "${BASH_SOURCE[0]}")"

export DEFAULT_USER="1000";
export DEFAULT_GROUP="1000";

export USER_ID=`id -u`
export GROUP_ID=`id -g`
export USER=$USER


if [ "$USER_ID" == "0" ]; then
    export USER_ID=$DEFAULT_USER;
fi

if [ "$GROUP_ID" == "0" ]; then
    export GROUP_ID=$DEFAULT_GROUP;
fi


export DOCKER_COMPOSE_CMD="docker-compose";

if ! command -v docker-compose &> /dev/null
then
    export DOCKER_COMPOSE_CMD="docker compose";
fi

test -e "./.env" || { cp .env.example .env; };
#load .env
export $(egrep -v '^#' .env | xargs)

if [ $# -eq 0 ]; then
    echo "HELP:"
    echo "make env - copy .env.example to .env"
    echo "make db - load init bitrix database dump to mysql"
    echo "db import FILE - load FILE to mysql"
    echo "db renew - load dump from repo, fresh db and apply"
    echo "db - run db cli"
    echo "db export > file.sql - export db to file"
    echo "build - make docker build"
    echo "up - docker up in console"
    echo "up silent - docker up daemon"
    echo "down - docker down"
    echo "run - run in php container from project root"
    echo "test - run tests"
    echo "cli some_command - run scripts/cli.php some_command (migration, etc)"
    echo "cept some_command (cept generate:cept acceptance Test) - run codeception with params"
fi

function applyDump {
    cat $1 | docker exec -i ${PROJECT_PREFIX}_mysql mysql -u $MYSQL_USER -p"$MYSQL_PASSWORD" $MYSQL_DATABASE;
    return $?
}

function runInMySql {
    local command=$@
    docker exec -i ${PROJECT_PREFIX}_mysql su mysql -c "$command"
    return $?
}

function runInPhp {
    local command=$@
    echo $command;
    docker exec -i ${PROJECT_PREFIX}_php su www-data -c "$command"
    return $?
}

function enterInPhp {
    docker exec -it ${PROJECT_PREFIX}_php su www-data
    return $?
}

function enterInPhpAdmin {
    docker exec -it ${PROJECT_PREFIX}_php bash
    return $?
}

function makeDump {
    runInMySql "export MYSQL_PWD='$MYSQL_PASSWORD'; mysqldump -u $MYSQL_USER $MYSQL_DATABASE" > $1
    return $?
}

if [ "$1" == "make" ]; then
    if [ "$2" == "env" ]; then
            cp .env.example .env
    fi
    if [ "$2" == "db" ]; then
         applyDump database.sql;
    fi
    
    if [ "$2" == "dump" ]; then
        makeDump database.sql
    fi
fi

if [ "$1" == "db" ]; then
    if [ "$2" == "" ]; then
        docker exec -it ${PROJECT_PREFIX}_mysql mysql -u $MYSQL_USER -p"$MYSQL_PASSWORD" $MYSQL_DATABASE;
    fi

    if [ "$2" == "export" ]; then
        runInMySql "export MYSQL_PWD='$MYSQL_PASSWORD'; mysqldump -u $MYSQL_USER $MYSQL_DATABASE"
    fi

    if [ "$2" == "import" ]; then
        applyDump $3
    fi

    if [ "$2" == "renew" ]; then
      if [ -f containers/mysql/drop_all_tables.sql ]; then
        applyDump containers/mysql/drop_all_tables.sql
      fi
      if [ -f database.sql ]; then
        applyDump database.sql
      fi
    fi
fi

if [ "$1" == "build" ]; then
    ${DOCKER_COMPOSE_CMD} -p ${PROJECT_PREFIX} build 
fi

if [ "$1" == "up" ]; then
    ${DOCKER_COMPOSE_CMD} -p ${PROJECT_PREFIX} build
    if [ "$2" == "silent" ]; then
        ${DOCKER_COMPOSE_CMD} -p ${PROJECT_PREFIX} up -d
    else
        ${DOCKER_COMPOSE_CMD} -p ${PROJECT_PREFIX} up
    fi
fi

if [ "$1" == "down" ]; then
    ${DOCKER_COMPOSE_CMD} -p ${PROJECT_PREFIX} down
fi

if [ "$1" == "cli" -o "$1" == "mg" ]; then
    runInPhp php ${PROJECT_PREFIX}/local/modules/ds.migrate/tools/migrate.php "${@:2}"
fi

if [ "$1" == "run" ]; then
    runInPhp "${@:2}"
fi

if [ "$1" == "in" ]; then
    enterInPhp "${@:2}"
fi
if [ "$1" == "in-admin" ]; then
    enterInPhpAdmin "${@:2}"
fi
