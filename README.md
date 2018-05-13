# Provisioning environment for Tomcat 8 application
\* [Japanese version](/README.ja.md)

## 1. Overview
This project is the provisioning environment for Tomcat 8 application [(Spring4MvcExample)](https://github.com/d-saitou/Spring4MvcExample/).  
This provisioning environment executes the following procedure.

* Create a virtual machine
* Set up guest OS and required software
* Build and deploy the application
* Set up the database


## 2. Development Environment
This provisioning environment is under development in the following environment.

* Vagrant ~~1.9.8~~ \-> 2.1.1
* VirtualBox ~~5.1.26~~ \-> 5.2.12


## 3. Description
This provisioning environment uses the following tools for provisioning.

* Provisioning
  - Vagrant (+ shell script)
  - Ansible (\* Automatically installed on the guest OS during provisioning)
* Build and deploy
  - Maven (\* Automatically installed on the guest OS during provisioning)
  - Jenkins (\* Automatically installed on the guest OS during provisioning)

For the guest OS use CentOS 6.  
Also, you can connect to the guest OS desktop environment on Windows Remote Desktop.

### 3.1. Provisioning procedure
In this provisioning environment, provisioning is executed by the following procedure.  

<div style="text-align: center;">
	<img src="https://github.com/d-saitou/provisioning-environment-for-tomcat8/blob/images/ProvisioningProcedure.jpg">
</div>

### 3.2. User list
For the login information of various users, please refer to the following tables.

**[OS]**

| User    | Password | User home     | Description                          |
|:--------|:---------|:--------------|:-------------------------------------|
| vagrant | vagrant  | /home/vagrant | User of virtual machines for Vagrant |
| tomcat  | tomcat   | /apps         | User for starting Web applicaion     |

**[Application]**

| Application       | User   | Password | URL                                      | Description   |
|:------------------|:-------|:---------|:-----------------------------------------|:--------------|
| MySQL             | root   | root     | \-                                       |               |
| \* same as above  | spring | spring   | \* Database: spring4example              |               |
| Tomcat Manager    | admin  | root     | http://{ip-addr}:8080/manager/           |               |
| Jenkins           | admin  | root     | http://{ip-addr}:8080/jenkins/           |               |
| Spring4MvcExample | admin  | admin    | http://{ip-addr}:8080/Spring4MvcExample/ | Administrator |
| \* same as above  | user   | user     | \* same as above                         | Public user   |

### 3.3. Directory structure
Various Web applications are placed under the "tomcat" user's home directory.  
The directory structure is as follows.

| Path          | Description                                                                        |
|:--------------|:-----------------------------------------------------------------------------------|
| /opt/tomcat   | Tomcat installation directory                                                      |
| /opt/maven    | Maven installation directory                                                       |
| /apps         | "tomcat" user's home directory                                                     |
| /apps/bin     | Store execution files such as shell scripts                                        |
| /apps/conf    | Store application configuration files                                              |
| /apps/data    | Store data files for applications                                                  |
| /apps/logs    | Store application log files                                                        |
| /apps/src     | Store checked out sources (\* separate directory from Jenkins' checkout directory) |
| /apps/tmp     | Store temporary files                                                              |
| /apps/webapps | Directory for deploying various Web applications                                   |


## 4. How to use
Perform provisioning by the following procedure.

1. Install [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).

2. Check out this provisioning environment.

3. Open the following file, and change version and URL for downloading source as necessary.  

	* [/sync/provision/ansible/roles/mysql/defaults/main.yml](/sync/provision/ansible/roles/mysql/defaults/main.yml)  
	* [/sync/provision/ansible/roles/jdk/defaults/main.yml](/sync/provision/ansible/roles/jdk/defaults/main.yml)  
	* [/sync/provision/ansible/roles/maven/defaults/main.yml](/sync/provision/ansible/roles/maven/defaults/main.yml)  
	* [/sync/provision/ansible/roles/tomcat/defaults/main.yml](/sync/provision/ansible/roles/tomcat/defaults/main.yml)  
	* [/sync/provision/ansible/roles/jenkins/defaults/main.yml](/sync/provision/ansible/roles/jenkins/defaults/main.yml)  


4. Perform the following operation.  

	**[Windows]**  
	Run [init.bat](init.bat) .  

	**[Other OS]**  
	Execute the following commands.
  ```
  cd {this provisioning environment directory}
  vagrant plugin install vagrant-vbguest
  vagrant up
  ```


## 5. Note

### 5.1. IP address configulation
Since the IP address of the guest OS is set as a fixed value (192.168.33.11) in [Vagrantfile](Vagrantfile), please change it as necessary.

### 5.2. Confirm log file at error occurrence
The log file at provisioning is stored in the following path of the guest OS.  
If an error occurs, refer to the console display contents or log file.

```
/home/vagrant/provision.<yyyymmddHHMMSS>.log
```

### 5.3. Error termination when restarting Tomcat
Tomcat will be restarted several times during provisioning, but the reboot fails and the provisioning may end in error.  
In this case, provisioning will succeed if you execute the provisioning re-execution command below on the host OS.  
\* Currently the cause is unknown. It will be fixed if the cause is clarified.

```
vagrant provision
```

**ex:**
<div style="text-align: center;">
  <img src="https://github.com/d-saitou/provisioning-environment-for-tomcat8/blob/images/TomcatRestartError.jpg" width="95%">
</div>
