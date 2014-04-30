class puppet::db {
  # Install and configure puppetdb.
  class { 'puppetdb':
    require => Package[ 'puppetdb-terminus' ],
  }
  class { 'puppetdb::master::config': }

  
  # Run the command to copy relevant certificates to puppetdb
  # from the ones created for the puppet master.
  exec { 'puppetdb ssl setup':
    command => '/usr/sbin/puppetdb ssl-setup',
    require => [
      File['/etc/httpd/conf.d/puppetmaster.conf'],
    ],
    notify => Service[ 'puppetdb' ],
  }
}
