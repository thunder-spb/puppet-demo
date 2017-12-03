# $Id$
#
# Class: vagrant_environment
#
# This class sets up the vagrant environment
#
# Parameters:
#
# Actions:
#   - Setup vagrant environment
#
# Requires:
#
# Sample Usage:
#
# 2017 alex thunder shevchenko // iam@thunder.spb.ru
#
# =====================================================
class vagrant_environment(
  $provision_filedir                = hiera('provision_filedir'),
  ) {
  # Vagrant user is created by default, but this will setup the password (encrypted: vagrant)
  # By default, vagrant cannot log into SSH session.
  user { 'vagrant':
    ensure     => present,
    comment    => 'Vagrant User',
    home       => '/home/vagrant',
    managehome => true,
    password   => 'vaqRzE48Dulhs', # encrypted: vagrant
  }
  # remove ipv6 service
  file { '/etc/sysconfig/ip6tables':
    ensure => absent,
    notify => Service['ip6tables'],
  }

  service { 'ip6tables':
    ensure => stopped,
  }
  #-----------------------------------------------------------------------------
  # Workaround to fix permissions on hiera.yaml - fixes if we provision again.
  #-----------------------------------------------------------------------------
  file { '/tmp/vagrant-puppet/hiera.yaml':
    ensure => present,
    mode => 0777,
  }
}
