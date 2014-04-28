#Quick Manifest to stand up a demo Puppet Master
class base {
  include puppet
  include ohmyzsh

  service { 'iptables':
    ensure => 'stopped',
  }

  $vagrant = 'vagrant'
  $root = 'root'

  ohmyzsh::setup { "${vagrant}":
    user => "${vagrant}",
  }

  ohmyzsh::setup { "${root}":
    user => "${root}",
  }
}

node 'puppetmaster.edina.ac.uk' {
  include base
include  puppet::master
  # class { 'puppet::master':
  #   apache => 'true',
  # }

}

node 'puppetagent.edina.ac.uk' {
  include base
}
