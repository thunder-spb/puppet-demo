class system_tools::sudo {
  package { 'sudo':
    ensure  => installed,
  }
  file { '/etc/sudoers.d':
    ensure => directory,
    mode   => '0750',
    owner  => 'root',
    group  => 'root',
    require => Package['sudo'],
  }
}
