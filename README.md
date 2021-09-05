# Provisioning environment for Tomcat application
\* [Japanese version](/README.ja.md)

## 1. Overview
This project is the provisioning environment for Tomcat application [(spring-mvc-example)](https://github.com/d-saitou/spring-mvc-example).  
This provisioning environment handles the following operations.

* Create a virtual machine
* Set up guest OS and required software
* Build and deploy the application
* Set up the database


## 2. Description
This provisioning environment uses the following tools for provisioning.

* Provisioning
  - Vagrant (+ shell script)
  - Ansible
* Build and deploy
  - Maven
  - Jenkins

### 2.1. Provisioning procedure
In this provisioning environment, provisioning is executed by the following procedure.  

<div style="text-align: center;">
	<img src="https://github.com/d-saitou/provisioning-environment-for-tomcat8/blob/images/ProvisioningProcedure.jpg">
</div>

### 2.2. Credentials and URLs

**[OS]**

| User    | Password | User home     | Description                            |
|:--------|:---------|:--------------|:---------------------------------------|
| vagrant | vagrant  | /home/vagrant | User of virtual machines for Vagrant   |
| tomcat  | tomcat   | \-            | User running tomcat                    |
| apps    | apps     | /apps         | Store files related to the application |

**[Application]**

| Application        | User    | Password   | URL                                       | Description   |
|:-------------------|:--------|:-----------|:------------------------------------------|:--------------|
| MySQL              | root    | Adm1N@1234 | \-                                        |               |
|                    | example | example    | \*Database: example                       |               |
| Tomcat Manager     | admin   | admin      | http://{ip-addr}:8080/manager/            |               |
| spring-mvc-example | admin   | admin      | http://{ip-addr}:8080/spring-mvc-example/ | Administrator |
|                    | user    | user       |                                           | Public user   |
| Jenkins            | admin   | admin      | http://{ip-addr}:18080/jenkins/           |               |
| maildev            | \-      | \-         | http://{ip-addr}:1080/                    |               |

### 2.3. Directory structure

| Path          | Description                                                                       |
|:--------------|:----------------------------------------------------------------------------------|
| /opt/tomcat   | Tomcat installation directory                                                     |
| /opt/maven    | Maven installation directory                                                      |
| /apps         | "apps" user's home directory                                                      |
| /apps/bin     | Store files such as batches and shell scripts                                     |
| /apps/conf    | Store application configuration files                                             |
| /apps/data    | Store data files for applications                                                 |
| /apps/logs    | Store application log files                                                       |
| /apps/src     | Store checked out sources (\*separate directory from Jenkins' checkout directory) |
| /apps/webapps | Use as appBase directory of tomcat                                                |


## 3. How to use

1. Install [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).

2. Clone this provisioning environment.

3. Perform the following operation.  

	**[Windows]**  
	Run [init.bat](init.bat) .  

	**[Other OS]**  
	Execute the following commands.
  ```
  cd {this provisioning environment directory}
  vagrant plugin install vagrant-vbguest
  vagrant up
  ```


## 4. Note

### 4.1. IP address configulation
Since the IP address of the guest OS is set as a fixed value (192.168.33.11) in [Vagrantfile](Vagrantfile), please change it as necessary.

### 4.2. Confirm log file at error occurrence
The log file at provisioning is stored in the following path of the guest OS.  
If an error occurs, refer to the console display contents or log file.

```
/home/vagrant/provision.<yyyymmddHHMMSS>.log
```
