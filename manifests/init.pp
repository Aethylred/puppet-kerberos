# Class: kerberos
#
# This module manages kerberos
#
# [Remember: No empty lines between comments and class definition]
class kerberos (
  $ensure      = 'present',
  $package     = $::kerberos::params::package,
  $config_file = $::kerberos::params::config_file
) inherits kerberos::params {

  case $ensure {
    'present': {
      $package_ensure = 'installed'
      $file_ensure    = 'file'
      $dir_ensure     = 'directory'
    }
    'latest': {
      $package_ensure = 'latest'
      $file_ensure    = 'file'
      $dir_ensure     = 'directory'
    }
    default: {
      $package_ensure = 'absent'
      $file_ensure    = 'absent'
      $dir_ensure     = 'absent'
    }
  }

  package { $package:
    ensure => $package_ensure,
  }

  concat { 'kerberos_config':
    ensure         => $ensure,
    path           => $config_file,
    warn           => '# This file is managed by Puppet, changes may be overwritten.',
    force          => true,
    ensure_newline => true,
    owner          => 'root',
    group          => 'root',
    mode           => '0644',
    require        => Package[$package]
  }


}
