# this turns off the virutal package warning message
if versioncmp($::puppetversion, '3.6.0') >= 0 {
    Package {
        allow_virtual => false,
    }
}

if $::osfamily != 'RedHat' {
  fail( "Unsupported OSFamily ${::osfamily}" )
}

# Include modules
include vagrant_environment
include vagrant_environment::common_packages

include system_tools::firewall

include dev_tools::oracle_jdk8
include dev_tools::maven
include dev_tools::groovy

include dev_tools::ansible
include dev_tools::rpmbuild

#
