##
# Simplified version of groovy installer
# Author: alex thunder shevchenko // iam@thunder.spb.ru 2017
##
class dev_tools::groovy (
  $versions = hiera('groovy_versions'),
  $default_version = hiera('groovy_default'),
  $service_homedir = hiera('default_homedir'),
) {
  
  $install_dir = '/opt/groovy'
  $default_version_dir = "${install_dir}/groovy-${default_version}"

  require dev_tools::oracle_jdk8

  define install_groovy($install_dir) {
    $version = $name
    $tmp_filename = "apache-groovy-binary-${version}.zip"
    $uri_prefix = hiera('groovy_uri_prefix')
    exec { "download groovy-${version}":
      cwd     => "/tmp",
      creates => "/tmp/${tmp_filename}",
      path    => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
      command => "/usr/bin/wget -c --no-check-certificate --no-cookies --header \"Cookie: oraclelicense=accept-securebackup-cookie\" \"${uri_prefix}/${tmp_filename}\" -O \"/tmp/${tmp_filename}\"",
      timeout => 600,
      require => Package['wget'],
    }    
    exec { "install groovy-${version}":
      cwd     => "${install_dir}",
      creates => "${install_dir}/groovy-${version}/LICENSE",
      path    => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
      command => "/bin/unzip /tmp/${tmp_filename}",
      require => [Exec["download groovy-${version}"],File["${install_dir}"]]
    }
  }
  file { "${install_dir}":
    ensure => directory,
  }
  install_groovy{ $versions: install_dir => $install_dir }

  file { "${install_dir}/groovy_default":
    ensure    => link,
    target    => "${default_version_dir}",
    require   => Exec["install groovy-${default_version}"]
  } ->
  file { "/etc/profile.d/groovy.sh":
    content => "export GROOVY_HOME=${install_dir}/groovy_default
      export PATH=\$GROOVY_HOME/bin:\$PATH
      "
  }

}