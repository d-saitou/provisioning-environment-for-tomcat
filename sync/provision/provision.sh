#!/bin/bash
# 
# Provisioning script for Tomcat application
# 
# auther: d-saitou
# release: 2021/09/05
# 
readonly LOG=./provision.`date +"%Y%m%d%H%M%S"`.log
readonly ANSIBLELOGDIR=./ansible
readonly PLAYBOOKDIR=./sync/provision/ansible

function main() {
	
	# Check user
	if [ `whoami` != "root" ] ; then
		echo "Please change to root user."
		return 1
	fi
	
	# Execute provisioning
	provision 2>&1 | while read LINE; do
		echo "$(date +"%Y/%m/%d %H:%M:%S") ${LINE}"
	done | tee ${LOG}
	
	return 0
}

function provision() {
	
	# Display start message
	echo " "
	echo "********************************************************************************"
	echo " Provisioning start..."
	echo "********************************************************************************"
	echo " "
	
	# Install ansible
	echo "Add epel repository..."
	yum -y --quiet install epel-release
	if [ ${?} -ne 0 ] ; then
		return 1
	fi
	echo " "
	
	echo "Install ansible..."
	yum -y --quiet install ansible
	if [ ${?} -ne 0 ] ; then
		return 1
	fi
	echo " "
	
	# Create ansible log directory
	if [ ! -d ${ANSIBLELOGDIR} ]; then
		mkdir ${ANSIBLELOGDIR}
	fi
	
	# Execute ansible playbook
	cd ${PLAYBOOKDIR}
	#ansible-playbook -v -i hosts -l appgroup site.yml
	ansible-playbook -i hosts -l appgroup site.yml
	RESULT=${?}
	
	# Display end message
	if [ ${RESULT} -eq 0 ] ; then
		echo " "
		echo "********************************************************************************"
		echo " Provisioning completed!"
		echo "********************************************************************************"
		echo " "
	else
		echo " "
		echo "********************************************************************************"
		echo " Provisioning failed!"
		echo "********************************************************************************"
		echo " "
	fi
	
	return ${RESULT}
}

main
exit ${?}
