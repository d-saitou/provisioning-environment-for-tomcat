#!/bin/bash
# 
# Provisioning script for Tomcat 8 application
# 
# auther: d-saitou
# version: 1.00
# release: 2018/03/03
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
	provision 2>&1 | tee ${LOG}
	
	return 0
}

function provision() {
	
	# Display start message
	echo " "
	echo "*************************"
	echo " Provisioning start..."
	echo "*************************"
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
	#ansible-playbook -v -i hosts -l app-group site.yml
	ansible-playbook -i hosts -l app-group site.yml
	RESULT=${?}
	
	# Display end message
	if [ ${RESULT} -eq 0 ] ; then
		echo " "
		echo "*************************"
		echo " Provisioning completed!"
		echo "*************************"
		echo " "
	else
		echo " "
		echo "*************************"
		echo " Provisioning failed!"
		echo "*************************"
		echo " "
	fi
	
	return ${RESULT}
}

main
exit ${?}
