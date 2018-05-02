#!/bin/bash
# 
# Jenkins restore script
# 
# auther: d-saitou
# version: 1.00
# release: 2018/03/03
# 
readonly ARGC=$#
readonly ARGV=(`echo $@`)

readonly JENKINS_HOME=${ARGV[0]}
readonly ARCHFILEPATH=${ARGV[1]}
readonly ARCHFILE=$(basename ${ARCHFILEPATH})
readonly TMPDIR="/tmp"
readonly WORKNAME="jenkins-backup"
readonly WORKDIR="${TMPDIR}/${WORKNAME}"

function main() {
	local RESULT=0
	
	if [ ${ARGC} -ne 2 ] ; then
		usage
		exit 1
	fi
	if [ ! -d ${JENKINS_HOME} ] ; then
		usage
		exit 1
	fi
	
	cleanup
	restore_jenkins
	RESULT=${?}
	cleanup
	
	if [ ${RESULT} -eq 0 ] ; then
		echo "Restore completed!"
	else
		echo "Restore failed!" >&2
	fi
	exit ${RESULT}
}

function usage() {
	echo "usage: $(basename $0) [\$JENKINS_HOME path] [backup-file-path(ex:archive.tar.gz)]"
}

function restore_jenkins() {
	
	mkdir -p ${WORKDIR}
	[ ${?} -ne 0 ] && return 1
	
	cp ${ARCHFILEPATH} ${WORKDIR}/
	[ ${?} -ne 0 ] && return 1
	
	cd ${WORKDIR}/
	[ ${?} -ne 0 ] && return 1
	
	tar xzf ${ARCHFILE}
	[ ${?} -ne 0 ] && return 1
	
	cp -R ${WORKNAME}/* ${JENKINS_HOME}/
	[ ${?} -ne 0 ] && return 1
	
	cd - >/dev/null
	return 0
}

function cleanup() {
	rm -rf ${WORKDIR}
}

main

