class system_tools::epel_repo {

    package { "epel-release":
      ensure    => installed,
    }
}  
