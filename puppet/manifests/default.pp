# this turns off the virutal package warning message
if versioncmp($::puppetversion, '3.6.0') >= 0 {
    Package {
        allow_virtual => false,
    }
}

# Include modules

