#!/usr/bin/env groovy
import jenkins.model.*

class CompletionCheck {

  static final int JENKINS_INSTALLSTATE_WAIT_TIME_SEC = 60
  def script = new File(this.class.protectionDomain.codeSource.location.file)
  def flagDirPath = script.absoluteFile.parent + '/flag'

  void log(logLevel, message) {
    println new Date().format('yyyy-MM-dd HH:mm:ss.SSSZ') + " [${script.getName()}] " + String.format("%-7s", logLevel) + " ${message}"
  }

  void main() {
    if (new File(flagDirPath).exists()) {
      log('INFO', 'Check the completion of all scripts and create a completion flag file.')

      // check the completion of all scripts.
      def isConfigurationSuccessful = true
      if (! new File("${flagDirPath}/1_SecurityAndLocationConfig").exists())
        isConfigurationSuccessful = false
      if (! new File("${flagDirPath}/2_PluginInstall").exists())
        isConfigurationSuccessful = false
      if (! new File("${flagDirPath}/3_MavenInstall").exists())
        isConfigurationSuccessful = false
      if (! new File("${flagDirPath}/4_CredentialsConfig").exists())
        isConfigurationSuccessful = false

      // create completion flag.
      def f = new File(flagDirPath + '/configuration.flg')
      f.write(isConfigurationSuccessful ? 'SUCCESS' : 'FAILURE', 'utf8')
    }
  }

}

def completionCheck = new CompletionCheck()
completionCheck.main()
