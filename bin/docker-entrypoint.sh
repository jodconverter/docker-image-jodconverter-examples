#!/usr/bin/env bash
# See this post for an explanation:
# https://medium.com/@matt_rasband/dockerizing-a-spring-boot-application-6ec9b9b41faf

echo "Java mem options ${JAVA_MEM_OPTS}"


if [ "$1" = "java" ]; then
    # the case where the user uses his own java -jar startup command - let him do that
    exec "$@" > >(tee -a ${LOG_BASE_DIR}/app.log) 2> >(tee -a ${LOG_BASE_DIR}/app.err >&2)
else
    exec java -jar ${JAR_FILE_BASEDIR}/${JAR_FILE_NAME} "$@" > >(tee -a ${LOG_BASE_DIR}/app.log) 2> >(tee -a ${LOG_BASE_DIR}/app.err >&2)
fi

