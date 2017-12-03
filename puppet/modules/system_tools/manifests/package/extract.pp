##
# Description:
#   extract provided archive
# Usage:
#  system_tools::package::extract{ "/path/to/archive/filename.zip", "/target/path" }
# Using this as require option:
# file { "parameter":
#   require => System_tools::Package::Extract["/path/to/archive/filename.zip"]
#   <some other parameters>
# }
#
# Author: alex thunder shevchenko, 2015 // iam@thunder.spb.ru
##

define system_tools::package::extract(
  $place,
  $timeout = 300,
) {

  $archive_name = $name
  # check extension
  case $archive_name {
    /\.(zip|jar|war)$/: {
      require system_tools::unzip
      $command = "unzip -quo \"${archive_name}\" -d \"${place}\""
    }
    /\.(tar|tgz|tbz|tar\.gz|tar\.bz2)$/: {
      require system_tools::tar
      $command = "tar -xf \"${archive_name}\""
    }
    default: {
        fail("Unsupported archive format ${archive_name}")
    }
  }
  # Unpack need file
  exec { "extract ${archive_name}":
    command   => $command,
    path      => ["/bin", "/usr/bin"],
    subscribe => File[$archive_name],
    refreshonly => true,
    timeout   => $timeout,
    returns   => [0,1],
    cwd       => $place,
  }

}
#
