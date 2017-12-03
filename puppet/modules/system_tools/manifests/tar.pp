class system_tools::tar {
  package { ["tar", "bzip2", "gzip"]:
    ensure  => installed,
  }
}