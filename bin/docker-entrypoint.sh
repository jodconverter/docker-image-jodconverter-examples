#!/usr/bin/env bash
# See this post for an explanation:
# https://medium.com/@matt_rasband/dockerizing-a-spring-boot-application-6ec9b9b41faf
function calculate_java_mem_opts()
{
  # You should make these values be dynamic based on your env, but I made
  # them static to make the usage a little more obvious:
  #APPLICATION_TOTAL_MEMORY=512M  # how much memory is available, see /sys/fs/cgroup/memory/* if in Docker
  #APPLICATION_SIZE_ON_DISK_IN_MB=120  # how big on disk, e.g. `du -h target/*.jar`

  APPLICATION_TOTAL_MEMORY=$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes | awk '{ byte = $1 /1024/1024 ; print byte "M";}')
  APPLICATION_SIZE_ON_DISK_IN_MB=$(ls -l ${JAR_FILE_BASEDIR}/${JAR_FILE_NAME} | awk '/d|-/{printf("%.0f",$5/(1024*1024))}')

  # Calculations based on "rules of thumb" from
  # https://github.com/dsyer/spring-boot-memory-blog/blob/master/cf.md
  loaded_classes=$(($APPLICATION_SIZE_ON_DISK_IN_MB * 400))
  stack_threads=$((15 + $APPLICATION_SIZE_ON_DISK_IN_MB * 6 / 10))

  export JAVA_MEM_OPTS=$(java-buildpack-memory-calculator-linux \
    -loadedClasses $loaded_classes \
    -poolType metaspace \
    -stackThreads $stack_threads \
    -totMemory ${APPLICATION_TOTAL_MEMORY})

  JAVA_MEM_OPTS="${JAVA_MEM_OPTS} -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1"
}

calculate_java_mem_opts

echo "Java mem options ${JAVA_MEM_OPTS}"
exec java -jar ${JAR_FILE_BASEDIR}/${JAR_FILE_NAME} "$@" ${JAVA_MEM_OPTS} > >(tee -a ${LOG_BASE_DIR}/app.log) 2> >(tee -a ${LOG_BASE_DIR}/app.err >&2)