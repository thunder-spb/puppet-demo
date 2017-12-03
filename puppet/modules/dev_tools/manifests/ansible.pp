class dev_tools::ansible {

  require system_tools::epel_repo

  package {'ansible':
    ensure  => installed,
  }
  package {'libselinux-python':
    ensure  => latest,
  }
}