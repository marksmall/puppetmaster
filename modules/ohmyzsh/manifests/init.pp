# Defininition: ohmyzsh
#
#   A class to ensure oh-my-zsh dependencies are installed.
#
#   Parameters: NONE
#
#   Usage:
#
#     include ohmyzsh
# 
class ohmyzsh {
  # Only install package if it doesn't already exist.
  if ! defined(Package['zsh']) {
    package { 'zsh':
      ensure => installed,
    }
  }

  if ! defined(Package['git']) {
    package { 'git':
      ensure => installed,
    }
  }
}
