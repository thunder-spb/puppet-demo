# Class: jenkins_server::plugins
#
# Helper class to preinstall Jenkins plugins
#
class jenkins_server::plugins {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  create_resources('jenkins_server::plugin_install',$jenkins_server::plugin_hash)

}