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

include jenkins_server
include dev_tools::groovy

include dev_tools::ansible
#
