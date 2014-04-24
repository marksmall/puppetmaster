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
  include puppet::master
}

node 'puppetagent.edina.ac.uk' {
  include base
}
