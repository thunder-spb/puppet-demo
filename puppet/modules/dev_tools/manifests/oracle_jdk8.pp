##
# Simplified version of oracle jdk8 installer
# 
# Good example is here: https://github.com/tylerwalts/puppet-jdk_oracle
#
# Author: alex thunder shevchenko // iam@thunder.spb.ru 2015-2017
##
class dev_tools::oracle_jdk8 (
  $provision_homedir = hiera('provision_homedir'),
  $oracle_jdk8_uri = hiera('oracle_jdk8_uri'),
) {
  $installerFilename = "jdk8-linux-x64.rpm"
  exec { "download oracle-jdk8":
    cwd     => "${provision_homedir}",
    creates => "/${provision_homedir}/${installerFilename}",
    path    => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
    command => "/usr/bin/wget -c --no-check-certificate --no-cookies --header \"Cookie: oraclelicense=accept-securebackup-cookie\" \"${oracle_jdk8_uri}\" -O \"${provision_homedir}/${installerFilename}\"",
    timeout => 600,
    # onlyif  => 'rpm -qi grep jdk1.8-1.8.0_151 >/dev/null 2>&1',
    require => Package['wget'],
  }
  exec { 'install jdk8':
    cwd     => '/tmp',
    path    => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
    creates => '/usr/bin/java',
    command => "rpm -Uvh ${provision_homedir}/${installerFilename}",
    require => Exec['download oracle-jdk8'],
    # onlyif  => 'exit `rpm -qa|grep jdk1.8-1.8.0_151|wc -l`',
  }
}