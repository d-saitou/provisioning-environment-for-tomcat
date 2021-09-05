#!/usr/bin/env groovy
import groovy.json.JsonSlurper
import jenkins.model.*

class MavenInstall {

  static final String CONFIG_JSON_FILE = './config.json'
  def script = new File(this.class.protectionDomain.codeSource.location.file)
  def flagDirPath = script.absoluteFile.parent + '/flag'
  def flagFIlePath = flagDirPath + '/' + script.getName().substring(0, script.getName().lastIndexOf('.'))

  void log(logLevel, message) {
    println new Date().format('yyyy-MM-dd HH:mm:ss.SSSZ') + " [${script.getName()}] " + String.format("%-7s", logLevel) + " ${message}"
  }

  void main() {
    def instance = Jenkins.getInstance()
    //if (!instance.getInstallState().isSetupComplete()) {
    if (!new File(flagFIlePath).exists() && new File(flagDirPath).exists()) {
      def configMap = new JsonSlurper().parse(new File(script.absoluteFile.parent + '/' + CONFIG_JSON_FILE))
      def name = configMap['maven']['name']
      def installMode = configMap['maven']['install_mode']
      def installVersion = configMap['maven']['install_version']
      def installedPath = configMap['maven']['installed_path']
      log('DEBUG', "[config-params] name:${name}, install_mode:${installMode}, install_version:${installedPath}, installed_path:${installVersion}")

      log('INFO', 'Checking Maven installation...')
      def mavenPlugin = instance.getExtensionList(hudson.tasks.Maven.DescriptorImpl.class)[0]

      // Check for a matching installation.
      def installedMaven = mavenPlugin.installations.find {
        install -> install.name.equals(this.config.maven_name)
      }

      // If no match was found, add an installation.
      if (installedMaven == null) {
        def mavenInstallation = null
        if ("install".equals(installMode)) {
          mavenInstallation = new hudson.tasks.Maven.MavenInstallation(
              name, null, [new hudson.tools.InstallSourceProperty([new hudson.tasks.Maven.MavenInstaller(installVersion)])])
        } else if ("installed".equals(installMode)) {
          mavenInstallation = new hudson.tasks.Maven.MavenInstallation(name, installedPath, [])
        }
        mavenPlugin.installations += mavenInstallation
        mavenPlugin.save()
        log('INFO', 'Maven install added.')
      } else {
        log('INFO', 'Maven install found.')
      }

      // create completion flag.
      new FileWriter(flagFIlePath).close()
    }
  }

}

def mavenInstall = new MavenInstall()
mavenInstall.main()
