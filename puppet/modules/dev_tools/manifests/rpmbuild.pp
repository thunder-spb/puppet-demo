class dev_tools::rpmbuild {
  package {'rpm-build':
    ensure  => installed,
  }
}