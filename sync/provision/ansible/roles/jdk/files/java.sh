export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))
export PATH=${PATH}:${JAVA_HOME}/bin
