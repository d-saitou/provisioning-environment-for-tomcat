#!/bin/sh
LOGFILE=/var/log/maildev.log

start() {
	local PID=$(ps -e -o "pid,args" | grep maildev | grep -v -e maildev.sh -e ${LOGFILE} -e grep -e sudo | awk '{ print $1 }' | xargs)
	if [ -z "${PID}" ]; then
		node /usr/local/lib/node_modules/maildev/bin/maildev 2>&1 | tee -a ${LOGFILE}
	fi
	return ${?}
}

stop() {
	local PID=$(ps -e -o "pid,args" | grep maildev | grep -v -e maildev.sh -e ${LOGFILE} -e grep -e sudo | awk '{ print $1 }' | xargs)
	local RET=0
	local PSALIVE=0
	if [ -n "${PID}" ]; then
		RET=$(kill ${PID} >/dev/null 2>&1; echo ${?})
		PSALIVE=$(kill -0 ${PID} >/dev/null 2>&1; echo ${?})
		while [ "$PSALIVE" = "0" ]
		do
			sleep 1
			PSALIVE=$(kill -0 ${PID} >/dev/null 2>&1; echo ${?})
		done
	fi
	return ${RET}
}

case "${1}" in
	start)
		start
		;;
	stop)
		stop
		;;
	reload)
		stop
		start
		;;
	*)
		echo "Usage: ${0} {start|stop|reload}"
		exit 1
		;;
esac
exit ${?}
