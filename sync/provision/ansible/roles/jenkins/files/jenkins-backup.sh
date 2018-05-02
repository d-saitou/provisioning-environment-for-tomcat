#!/bin/bash
# 
# Jenkins backup script
# 
# auther: d-saitou
# version: 1.00
# release: 2018/03/03
# 
# reference:
#  jenkins-backup-script
#   Copyright (c) 2015 sue445
#   Licensed under the MIT license.
#   https://github.com/sue445/jenkins-backup-script/blob/master/LICENSE.txt
# 
readonly ARGC=$#
readonly ARGV=(`echo $@`)

readonly JENKINS_HOME=${ARGV[0]}
readonly ARCHFILE=${ARGV[1]}
readonly TMPDIR="/tmp"
readonly WORKNAME="jenkins-backup"
readonly WORKDIR="${TMPDIR}/${WORKNAME}"
readonly WORKFILE="${TMPDIR}/archive.tar.gz"

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
	backup_jenkins
	RESULT=${?}
	if [ ${RESULT} -eq 0 ] ; then
		compress_to_file
		RESULT=${?}
	fi
	cleanup
	
	if [ ${RESULT} -eq 0 ] ; then
		echo "Backup completed!"
	else
		echo "Backup failed!" >&2
	fi
	exit ${RESULT}
}

function usage() {
	echo "usage: $(basename $0) [\$JENKINS_HOME path] [backup-file-path(ex:archive.tar.gz)]"
}

function backup_jenkins() {
	
	mkdir -p ${WORKDIR}
	cp -p ${JENKINS_HOME}/*.xml ${WORKDIR}
	[ ${?} -ne 0 ] && return 1
	
	mkdir -p ${WORKDIR}/users
	if [ $(ls -A ${JENKINS_HOME}/users/ | wc -l) -gt 0 ]; then
		cp -pR ${JENKINS_HOME}/users/* ${WORKDIR}/users
		[ ${?} -ne 0 ] && return 1
	fi
	
	mkdir -p ${WORKDIR}/secrets
	if [ $(ls -A ${JENKINS_HOME}/secrets | wc -l) -gt 0 ] ; then
		cp -pR ${JENKINS_HOME}/secrets/* ${WORKDIR}/secrets
		[ ${?} -ne 0 ] && return 1
	fi
	
	mkdir -p ${WORKDIR}/nodes
	if [ $(ls -A ${JENKINS_HOME}/nodes | wc -l) -gt 0 ] ; then
		cp -pR ${JENKINS_HOME}/nodes/* ${WORKDIR}/nodes
		[ ${?} -ne 0 ] && return 1
	fi
	
	mkdir -p ${WORKDIR}/userContent
	if [ $(ls -A ${JENKINS_HOME}/userContent | wc -l) -gt 0 ] ; then
		cp -pR ${JENKINS_HOME}/userContent/* ${WORKDIR}/userContent
		[ ${?} -ne 0 ] && return 1
	fi
	
	mkdir -p ${WORKDIR}/plugins
	cp -p ${JENKINS_HOME}/plugins/*.[hj]pi ${WORKDIR}/plugins
	[ ${?} -ne 0 ] && return 1
	PINNEDCNT=$(find ${JENKINS_HOME}/plugins/ -name *.[hj]pi.pinned | wc -l)
	if [ ${PINNEDCNT} -gt 0 ]; then
		cp -p ${JENKINS_HOME}/plugins/*.[hj]pi.pinned ${WORKDIR}/users
		[ ${?} -ne 0 ] && return 1
	fi
	
	mkdir -p ${WORKDIR}/jobs
	if [ $(ls -A ${JENKINS_HOME}/jobs | wc -l) -gt 0 ] ; then
		backup_jenkins_jobs ${JENKINS_HOME}/jobs/
		[ ${?} -ne 0 ] && return 1
	fi
	
	return 0
}

function backup_jenkins_jobs() {
	local JOBBASEPATH=${1}
	local JOBPATH=${JOBBASEPATH#${JENKINS_HOME}/jobs/}
	if [ -d ${JOBBASEPATH} ] ; then
		cd ${JOBBASEPATH}
		find . -maxdepth 1 -type d | while read JOBNAME ; do
			[ ${JOBNAME} = "." ] && continue
			[ ${JOBNAME} = ".." ] && continue
			[ -d ${JOBNAME} ] && mkdir -p ${WORKDIR}/jobs/${JOBPATH}/${JOBNAME}
			find ${JOBNAME}/ -maxdepth 1 -name "*.xml" -print0 | xargs --null -I {} cp -p {} ${WORKDIR}/jobs/${JOBPATH}/${JOBNAME}/
			[ ${?} -ne 0 ] && return 1
			if [ -f ${JOBNAME}/config.xml -a $(grep -c com.cloudbees.hudson.plugins.folder.Folder ${JOBNAME}/config.xml) -ge 1 ] ; then
				backup_jenkins_jobs ${JOBBASEPATH}/${JOBNAME}/jobs
				[ ${?} -ne 0 ] && return 1
			fi 
		done
		cd - >/dev/null
	fi
	return 0
}

function compress_to_file() {
	cd ${TMPDIR}
	tar -czf ${WORKFILE} ${WORKNAME}/*
	[ ${?} -ne 0 ] && return 1
	
	cd - >/dev/null
	mv -f ${WORKFILE} ${ARCHFILE}
	[ ${?} -ne 0 ] && return 1
	
	return 0
}

function cleanup() {
	rm -rf ${WORKDIR} ${WORKFILE}
}

main

