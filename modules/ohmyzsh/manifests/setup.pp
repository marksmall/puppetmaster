# Defininition: ohmyzsh::setup
#
#   A new resource type to configure a oh-my-zsh installation for
#   a particular user.
#
#   Parameters:
#     * user: User account to install oh-my-zsh for.
#
#   Usage:
#
#     $vagrant = 'vagrant'
#     $root = 'root'
#
#     ohmyzsh::setup { "${vagrant}":
#       user => "${vagrant}",
#     }
#
#     ohmyzsh::setup { "${root}":
#       user => "${root}",
#     }
# 
define ohmyzsh::setup($user) {
  # Root's home directory is different from all other accounts.
  if $user == 'root' {
    $home = "/${user}"
  }
  else {
    $home = "/home/${user}"
  }
  
  # Clone oh-my-zsh
  exec { "clone oh-my-zsh ${user}":
    cwd     => "${home}",
    user    => "${user}",
    command => "/usr/bin/git clone https://github.com/robbyrussell/oh-my-zsh.git ${home}/.oh-my-zsh",
    creates => "${home}/.oh-my-zsh",
    require => [ Package['git'], Package['zsh']]
  }

  # Set file defaults.
  File {
    ensure => "present",
    owner  => "${user}",
    group  => "${user}",
    replace => false,
    mode   => 0644,
  }

  # Set configuration
  file { "${home}/.zshrc":
    source => "puppet:///modules/ohmyzsh/zshrc",
    require => Exec["clone oh-my-zsh ${user}"]
  }

  # My variation of the agnoster theme.
  file { "/${home}/.oh-my-zsh/themes/msmall-agnoster.zsh-theme":
    source => "puppet:///modules/ohmyzsh/msmall-agnoster.zsh-theme",
    require => Exec["clone oh-my-zsh ${user}"]
  }

  # Set the shell
  exec { "/usr/bin/chsh -s /bin/zsh ${user}":
#    unless  => "grep -E '^\$\{user\}.+:/bin/zsh$' /etc/passwd",
    require => Package['zsh']
  }
}
