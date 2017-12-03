class jenkins_server::service {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  service { 'jenkins':
    ensure => running,
    enable => true,
    hasstatus  => true,
    hasrestart => true,
    require => Exec['install jenkins'],
  }

}