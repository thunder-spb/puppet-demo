##
# Simplifies Jenkins plugin installation
#
# Usage:
# By default it will install latest version:
# 
#   jenkins_server::plugin_install {
#     "git" : ;
#   }
#   
# Install by version:
# 
#   jenkins_server::plugin_install {
#     "git" :
#        version => "1.1.11";
#   }
# Author: alex thunder shevchenko // iam@thunder.spb.ru
##
define jenkins_server::plugin_install(
  $version=0,
  $plugins_mirror_uri = hiera('jenkins_plugins_mirror_uri')
) {

  require system_tools::wget

  $plugin            = "${name}.hpi"
  $plugin_dir        = '/var/lib/jenkins/plugins'
  $plugin_parent_dir = inline_template('<%= @plugin_dir.split(\'/\')[0..-2].join(\'/\') %>')

  if ($version != 0) {
    $base_url = "${plugins_mirror_uri}/${name}/${version}/"
    $search   = "${name} ${version}(,|$)"
  }
  else {
    $base_url = 'http://updates.jenkins-ci.org/latest/'
    $search   = "${name} "
  }

  if (!defined(File[$plugin_dir])) {
    file { [$plugin_parent_dir, $plugin_dir]:
      ensure  => directory,
      owner   => 'jenkins',
      group   => 'jenkins',
      mode    => '0755',
      require => [Group['jenkins'], User['jenkins']],
    }
  }

  if (!defined(Group['jenkins'])) {
    group { 'jenkins' :
      ensure  => present,
      require => Exec['install jenkins'],
    }
  }

  if (!defined(User['jenkins'])) {
    user { 'jenkins' :
      ensure  => present,
      home    => $plugin_parent_dir,
      require => Exec['install jenkins'],
    }
  }

  exec { "download-${name}" :
    command => "rm -rf ${name} ${name}.* && wget --no-check-certificate ${base_url}${plugin}",
    cwd     => $plugin_dir,
    require => [File[$plugin_dir], Package['wget'], Exec['install jenkins']],
    path    => ['/usr/bin', '/usr/sbin', '/bin'],
  }

  file { "${plugin_dir}/${plugin}" :
    owner   => 'jenkins',
    mode    => '0644',
    require => Exec["download-${name}"],
    notify  => Service['jenkins'],
  }

}