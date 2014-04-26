class puppet::master($apache = false) {
  notify { "Apache val is: ${apache}": }
  include puppet
  include puppet::params

  package { "puppet-server":
    ensure => installed,
  }

  if $apache == 'true' {
    class {'passenger': }  

    class { 'apache':
      default_mods  => false,
      default_vhost => false,
      mpm_module    => 'worker',
    }

    include apache::mod::deflate
    include apache::mod::status
    include apache::mod::mime
    include apache::mod::headers

    class { 'apache::mod::ssl':
      ssl_compression => false,
      ssl_options     => [ 'StdEnvVars' ],
    }

    $default_home = '/var/www/html'
    apache::vhost { "${fqdn}":
      port          => 80,
      docroot       => $default_home,
      serveradmin   => "root@$fqdn",
      priority      => '14',
      default_vhost => true,
      directories   => [{
        provider    => 'directory',
        path        => $default_home,
        allow       => "from all", # Fi this to real subnets.
        deny        => 'from all',
        order       => 'deny,allow',
      }],
    }

    package { "mod_ssl":
      ensure => present,
    }

    File {
      owner => "root",
      group => "root",
      mode  => "0644",
    }

    $puppet_dir = '/var/www/html/puppetmasterd'
    file { [ "${puppet_dir}",
             "${puppet_dir}/public",
             "${puppet_dir}/tmp" ]:
               ensure  => directory,
               require => Package['puppet-server'],
    }
    
    file { '/etc/httpd/conf.d/puppetmaster.conf':
      ensure  => 'present',
      content => template('puppet/puppetmaster.conf.erb'),
      require => [
        Package['mod_ssl'],
        Exec['puppetmaster-run-once'],
      ],
      notify  => Service['httpd'],
    }

    file { "${puppet_dir}/config.ru":
      ensure  => 'present',
      owner   => 'puppet',
      group   => 'puppet',
      source  => '/usr/share/puppet/ext/rack/config.ru',
      require => [
                  Package['puppet-server'],
                  File["${puppet_dir}"],
                  ],
      notify  => Service['httpd'],
    }

    # service { "puppetmaster":
    #   ensure     => stopped,
    #   enable     => false,
    #   hasrestart => true,
    #   hasstatus  => true,
    #   require    => [
    #                  Package["puppet-server"],
    #                  File["/etc/puppet/puppet.conf"],
    #                  ],
    # }

    # Short of a nice way to get the certificates generated just start up
    # puppetmaster and stop it again
    exec { "puppetmaster-run-once":
      command => "/sbin/service puppetmaster start && /sbin/service puppetmaster stop",
      creates => "/var/lib/puppet/ssl/certs/puppet.${domain}.pem",
      require => Service["puppetmaster"],
    }

    # service { "httpd":
    #   ensure     => running,
    #   enable     => true,
    #   hasrestart => true,
    #   hasstatus  => true,
    #   require    => [
    #     Package["httpd"],
    #     Package["mod_ssl"],
    #     Exec["puppetmaster-run-once"],
    #   ],
    # }

    $ensure = 'stopped'
    $enable = false
  } else {
    $ensure = 'running'
    $enable = true
  }

  service { "puppetmaster":
    ensure     => "${ensure}",
    enable     => "${enable}",
    hasrestart => true,
    hasstatus  => true,
    require    => [
      Package["puppet-server"],
      File["/etc/puppet/puppet.conf"],
    ],
  }          
}
