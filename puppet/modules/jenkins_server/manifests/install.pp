class jenkins_server::install (
  ) {
    $jenkins_version = hiera('jenkins_version')
    $mirror_uri = hiera('jenkins_mirror_uri')
    $jenkins_rpm_suffix = hiera('jenkins_rpm_suffix')
    $jenkins_name = "jenkins-${jenkins_version}"
    $jenkins_rpm = "${jenkins_name}${jenkins_rpm_suffix}"
    ## this prevents to call this class directly
    if $caller_module_name != $module_name {
        fail("Use of private class ${name} by ${caller_module_name}")
    }

    system_tools::open_port{ 'http': port => '8080', protocol => 'tcp', comment => 'HTTP port for Jenkins' }
    
    exec { "download Jenkins ${jenkins_version}":
      cwd     => "/tmp",
      creates => "/tmp/${jenkins_rpm}",
      path    => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
      command => "/usr/bin/wget -c --no-check-certificate --no-cookies --header \"Cookie: oraclelicense=accept-securebackup-cookie\" \"${mirror_uri}/${jenkins_rpm}\" -O \"/tmp/${jenkins_rpm}\"",
      timeout => 600,
      # onlyif  => 'rpm -qi grep jdk1.8-1.8.0_151 >/dev/null 2>&1',
      require => Package['wget'],
    }

    exec { 'install jenkins':
      cwd     => '/tmp',
      path    => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
      command => "rpm -Uvh ${jenkins_rpm}",
      require => Exec["download Jenkins ${jenkins_version}"],
    }
}


