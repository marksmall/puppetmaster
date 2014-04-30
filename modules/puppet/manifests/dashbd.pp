# Class: puppet::dashboard
#
# This class installs and configures the puppet dashboard
#
# Parameters:
#
# Actions:
#   - Install Apache
#   - Manage Apache service
#
# Requires:
#
# Sample Usage:
#
class puppet::dashbd {
  # Use the Puppetlabs supplied dashboard module handle the installation
  # and configuration of the dashboard web application.
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
  }
}
