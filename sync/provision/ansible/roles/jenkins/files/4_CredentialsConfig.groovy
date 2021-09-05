#!/usr/bin/env groovy
import groovy.json.JsonSlurper
import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.Domain
import com.cloudbees.plugins.credentials.impl.*

class CredentialsConfig {

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
      log('DEBUG', "[config-params] credentials:${configMap['credentials']}")

      def store = instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
      def usenamePasswordCredentials = configMap['credentials']['usename_password_credentials']
      usenamePasswordCredentials.each {
        def userId = it['user_id']
        def userName = it['user_name']
        def userPass = it['user_pass']
        def userDesc = it['user_desc']
        log('INFO', "Configure credentials user (user: ${userName}).")
        def credentialsUser = new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL, userId, userDesc, userName, userPass)
        store.addCredentials(Domain.global(), credentialsUser)
      }
      instance.save()

      // create completion flag.
      new FileWriter(flagFIlePath).close()
    }
  }

}

def credentialsConfig = new CredentialsConfig()
credentialsConfig.main()
