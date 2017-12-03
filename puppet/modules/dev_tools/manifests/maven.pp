##
# Simplified version of maven3 installer
# Author: alex thunder shevchenko // iam@thunder.spb.ru 2015
##
class dev_tools::maven (
  $versions = hiera('maven_versions'),
  $default_version = hiera('maven_default'),
  $service_homedir = hiera('default_homedir'),
) {
  
  $install_dir = '/opt/maven'
  $default_version_dir = "${install_dir}/apache-maven-${default_version}"

  require dev_tools::oracle_jdk8

  define install_maven($install_dir) {
    $version = $name
    $uri_prefix = 'http://mirror.cc.columbia.edu/pub/software/apache/maven/maven-3'
    $tmp_filename = "apache-maven-${version}-bin.tar.gz"
    exec { "download maven-${version}":
      cwd     => "/tmp",
      creates => "/tmp/${tmp_filename}",
      path    => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
      command => "/usr/bin/wget -c --no-check-certificate --no-cookies --header \"Cookie: oraclelicense=accept-securebackup-cookie\" \"${uri_prefix}/${version}/binaries/${tmp_filename}\" -O \"/tmp/${tmp_filename}\"",
      timeout => 600,
      require => Package['wget'],
    }
    exec { "install maven-${version}":
      cwd     => "${install_dir}",
      creates => "${install_dir}/apache-maven-${version}/bin",
      path    => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
      command => "/bin/tar xzf /tmp/${tmp_filename}",
      require => [Exec["download maven-${version}"], File["${install_dir}"]],
    }
  }
  file { "${install_dir}":
    ensure => directory,
  }
  install_maven{ $versions: install_dir => "${install_dir}" }
  
  file { "${install_dir}/maven_default":
    ensure    => link,
    target    => "${default_version_dir}",
    require   => Exec["install maven-${default_version}"]
  } ->
  file { "/etc/profile.d/maven.sh":
    content => "export MAVEN_HOME=${install_dir}/maven_default
      export M2=\$MAVEN_HOME/bin
      export PATH=\$MAVEN_HOME/bin:\$PATH
      export MAVEN_OPTS=\"-Xmx512m -Xms512m\"
      "
  }

  file { "${service_homedir}/.m2":
    ensure    => directory,
    require   => User['vagrant'],
  }
  # file { "${service_homedir}/.m2/settings.xml":
  #   path      => "${service_homedir}/.m2/settings.xml",
  #   source    => "puppet:///modules/dev_tools/maven/settings.xml",
  #   require   => [User['vagrant'], File["${service_homedir}/.m2"]],
  # }


}