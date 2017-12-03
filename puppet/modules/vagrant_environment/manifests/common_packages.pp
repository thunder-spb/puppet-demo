class vagrant_environment::common_packages {
    require system_tools::git
    require system_tools::unzip
    require system_tools::tar
    require system_tools::wget

    require system_tools::xmlstarlet

    require system_tools::midnight_commander

    require system_tools::epel_repo
}