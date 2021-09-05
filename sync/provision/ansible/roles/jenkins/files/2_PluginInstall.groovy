#!/usr/bin/env groovy
import java.lang.management.*
import groovy.json.JsonSlurper
import jenkins.model.*

class PluginInstall {

  static final int SITE_CHECK_TIME_SEC = 60
  static final String CONFIG_JSON_FILE = './config.json'
  def script = new File(this.class.protectionDomain.codeSource.location.file)
  def flagDirPath = script.absoluteFile.parent + '/flag'
  def flagFIlePath = flagDirPath + '/' + script.getName().substring(0, script.getName().lastIndexOf('.'))
  def pluginManager = null
  def updateCenter = null

  void log(logLevel, message) {
    println new Date().format('yyyy-MM-dd HH:mm:ss.SSSZ') + " [${script.getName()}] " + String.format("%-7s", logLevel) + " ${message}"
  }

  void enablePlugin(pluginName) {
    if (!pluginManager.getPlugin(pluginName)) {
      def deployment = updateCenter.getPlugin(pluginName).deploy(true)
      deployment.get()
    }
    def plugin = pluginManager.getPlugin(pluginName)
    if (!plugin.isEnabled()) {
      plugin.enable()
    }
    plugin.getDependencies().each {
      enablePlugin(it.shortName)
    }
  }

  void main() {
    def instance = Jenkins.getInstance()
    //if (!instance.getInstallState().isSetupComplete()) {
    if (!new File(flagFIlePath).exists() && new File(flagDirPath).exists()) {
      def configMap = new JsonSlurper().parse(new File(script.absoluteFile.parent + '/' + CONFIG_JSON_FILE))
      def plugins = configMap['plugins']
      log('DEBUG', "[config-params] plugins:${plugins}")

      pluginManager = instance.getPluginManager()
      updateCenter = instance.getUpdateCenter()

      def cnt = 0
      def isInstallReady = false
      while (++cnt <= SITE_CHECK_TIME_SEC) {
        log('DEBUG', "check the update center site...")
        updateCenter.getSiteList().each {
          isInstallReady = it.getData() != null ? true : isInstallReady
        }
        if (isInstallReady)
          break
        if (cnt == SITE_CHECK_TIME_SEC) {
          log('ERROR', 'update center check not completed!')
          return
        }
        sleep(1000)
      }

      plugins.each {
        log('INFO', "Install plugin (${it}).")
        enablePlugin(it)
      }

      // create completion flag.
      new FileWriter(flagFIlePath).close()
    }
  }

}

def pluginInstall = new PluginInstall()
pluginInstall.main()
