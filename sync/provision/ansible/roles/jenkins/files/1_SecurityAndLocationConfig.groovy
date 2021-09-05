#!/usr/bin/env groovy
import groovy.json.JsonSlurper
import jenkins.model.*
import hudson.security.*
import hudson.security.csrf.DefaultCrumbIssuer

class SecurityAndLocationConfig {

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
      def user_name = configMap['user']['name']
      def user_pass = configMap['user']['pass']
      def url = configMap['url']
      log('DEBUG', "[config-params] user.name:${user_name}, user.pass:${user_pass}, url:${url}")

      log('INFO', 'Configure jenkins security.')

      // create user.
      def realm = new HudsonPrivateSecurityRealm(false)
      realm.createAccount(user_name, user_pass)
      instance.setSecurityRealm(realm)

      // configure authorization strategy.
      def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
      strategy.setAllowAnonymousRead(true)
      instance.setAuthorizationStrategy(strategy)

      // configure crumb.
      if (instance.getCrumbIssuer() == null) {
      instance.setCrumbIssuer(new DefaultCrumbIssuer(true))
      }

      // save security configuration.
      instance.save()

      // configure location.
      log('INFO', 'Configure jenkins url.')
      def jlc = JenkinsLocationConfiguration.get()
      jlc.setUrl(url)
      jlc.save()

      // create completion flag.
      new FileWriter(flagFIlePath).close()
    }
  }

}

def securityAndLocationConfig = new SecurityAndLocationConfig()
securityAndLocationConfig.main()
