##
# Simplified Jenkins installer
#
# Author: alex thunder shevchenko // iam@thunder.spb.ru
##
class jenkins_server (
    $plugin_hash = {},
    ) {

    require dev_tools::oracle_jdk8

    ## Install jenkins server itself
    class { 'jenkins_server::install': }
    ## Preinstall plugins if any defined, see global.yaml
    class { 'jenkins_server::plugins': }
    class { 'jenkins_server::service': }

    Exec['install jdk8'] ->
      Class['jenkins_server::install'] ->
        Class['jenkins_server::plugins'] ~>
          Class['jenkins_server::service']

}