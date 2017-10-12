class httpd_root_config{

    # Ensure root directory exists
    file { "/var/www/s3547463":
        ensure => 'directory',
    }

    # Not working...
    # augeas { "httpd_conf":
    #   context => "/files/etc/httpd/conf/httpd.conf",
    #   changes => [
    #     'set DocumentRoot /var/www/s3547463',
    #   ],
    # }

    # Given the same template for http.conf can be used...
    # Move the files
    file {'/etc/httpd/conf/httpd.conf':
        source => '/etc/puppetlabs/code/environments/production/manifests/conf_files/httpd.conf',
    }

}

class setup_usr_bin_helper ($usr){
    file { "/home/$usr/usr":
        # Ensure wilma's home directory is created
        ensure => 'directory',
    }
    file { "/home/$usr/usr/local":
        # Ensure wilma's home directory is created
        ensure => 'directory',
    }
    file { "/home/$usr/usr/local/bin":
        # Ensure wilma's home directory is created
        ensure => 'directory',
    }
}


# Add /usr/local/bin to everyone's directory
class setup_user_bin{
    $user1='becca'
    $user2='fred'
    $user3='wilma'

    class { 'setup_usr_bin_helper':
            usr => $user1,
    }
}

class file_config{
    # Configure ssh root
    augeas { "sshd_config":
      context => "/files/etc/ssh/sshd_config",
      changes => [
        "set PermitRootLogin no",
      ],
    }

    augeas { "sudobecca":
        context => "/files/etc/sudoers",
        changes => [
          "set Defaults[type=':becca']/type :becca",
          "set Defaults[type=':becca']/requiretty/negate ''",
          "set spec[user = 'becca']/user becca",
          "set spec[user = 'becca']/host_group/host ALL",
          "set spec[user = 'becca']/host_group/command ALL",
          "set spec[user = 'becca']/host_group/command/runas_user ALL",
        ],
    }


    # Configure httpd root directory
    include 'httpd_root_config'
    # Add /usr/local/bin to each users path
    include 'setup_user_bin'
}
