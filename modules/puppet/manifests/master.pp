class puppet::master {
  include puppet
  include puppet::params

  package { "puppet-server":
    ensure => installed,
  }

#  class {'passenger': }  

  # class { 'apache':
  #   default_mods  => false,
  #   default_vhost => false,
  #   mpm_module    => 'worker',
  # }

  include apache
  include apache::mod::deflate
  include apache::mod::status
  include apache::mod::mime
  include apache::mod::headers

  class { 'apache::mod::ssl':
    ssl_compression => false,
    ssl_options     => [ 'StdEnvVars' ],
  }

  $default_home = '/var/www/html'
  # apache::vhost { "${fqdn}":
  #   port          => 80,
  #   docroot       => $default_home,
  #   serveradmin   => "root@$fqdn",
  #   priority      => '14',
  #   default_vhost => true,
  #   directories   => [{
  #     provider    => 'directory',
  #     path        => $default_home,
  #     allow       => "from all", # Fix this to use real subnets.
  #     deny        => 'from all',
  #     order       => 'deny,allow',
  #   }],
  # }

  File {
    owner => "root",
    group => "root",
    mode  => "0644",
  }

  $puppet_dir = '/var/www/html/puppetmasterd'
  file { [ "${puppet_dir}",
           "${puppet_dir}/production",
           "${puppet_dir}/public",
           "${puppet_dir}/tmp" ]:
    ensure  => directory,
    require => Package['puppet-server'],
  }
  
  file { "${puppet_dir}/config.ru":
    ensure  => 'present',
    owner   => 'puppet',
    group   => 'puppet',
    source  => '/usr/share/puppet/ext/rack/config.ru',
    require => [
      File["${puppet_dir}"],
    ],
    notify  => Service['httpd'],
  }

  file { '/etc/sysconfig/puppet':
    ensure  => 'present',
    content => template('puppet/etc/sysconfig/puppet.erb'),
  }

  # Short of a nice way to get the certificates generated just start up
  # puppetmaster and stop it again
  exec { "puppetmaster-run-once":
    command => "/sbin/service puppetmaster start && /sbin/service puppetmaster stop",
    creates => "/var/lib/puppet/ssl/certs/${fqdn}.pem",
    require => Service["puppetmasterd"],
  }


  service { "puppetmasterd":
    ensure     => 'stopped',
    enable     => false,
    hasrestart => true,
    hasstatus  => true,
    require    => [
      Package["puppet-server"],
      File["/etc/puppet/puppet.conf"],
    ],
  }          

  class { 'puppetdb':
    require => Package[ 'puppetdb-terminus' ],
  }
  class { 'puppetdb::master::config': }
  
  exec { 'puppetdb ssl setup':
    command => '/usr/sbin/puppetdb ssl-setup',
    require => [
      File['/etc/httpd/conf.d/puppetmaster.conf'],
#       Class['dashboard'],
    ],
    notify => Service[ 'puppetdb' ],
  }


  class {'dashboard':
    dashboard_ensure          => 'present',
    dashboard_user            => 'puppet-dbuser',
    dashboard_group           => 'puppet-dbgroup',
    dashboard_password        => 'changeme',
    dashboard_db              => 'dashboard_prod',
    dashboard_charset         => 'utf8',
    dashboard_site            => "${fqdn}",
    dashboard_port            => '8082',
    mysql_root_pw             => 'changemetoo',
    passenger                 => true,
#    passenger_install         => false,
  }
}
