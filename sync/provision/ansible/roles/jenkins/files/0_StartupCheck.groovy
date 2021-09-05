#!/usr/bin/env groovy
import jenkins.model.*

class StartupCheck {

//  static final int JENKINS_INSTALLSTATE_WAIT_TIME_SEC = 60
  static final int JENKINS_INSTALLSTATE_WAIT_TIME_SEC = 30
  def script = new File(this.class.protectionDomain.codeSource.location.file)
  def flagDirPath = script.absoluteFile.parent + '/flag'

  void log(logLevel, message) {
    println new Date().format('yyyy-MM-dd HH:mm:ss.SSSZ') + " [${script.getName()}] " + String.format("%-7s", logLevel) + " ${message}"
  }

  void main() {
    def instance = Jenkins.getInstance()
    //if (!instance.getInstallState().isSetupComplete()) {
    if (!new File(flagDirPath).exists()) {
      log('INFO', 'Start initial setup.')
      new File(flagDirPath).mkdirs();

      // Check installation status.
      def cnt = 0
      def installState = null
      while (++cnt <= JENKINS_INSTALLSTATE_WAIT_TIME_SEC) {
        installState = instance.getInstallState().name()
        log('DEBUG', "installState: ${installState}")
        if (installState.equals('NEW') || installState.equals('RESTART') || installState.equals('RUNNING')) {
          break
        }
        if (cnt == JENKINS_INSTALLSTATE_WAIT_TIME_SEC) {
          log('ERROR', 'installState does not transition to NEW or RESTART or RUNNING!')
        }
        sleep(1000)
      }
    }
  }

}

def startupCheck = new StartupCheck()
startupCheck.main()
