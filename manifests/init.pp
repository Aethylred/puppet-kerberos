# Class: kerberos
#
# This module manages kerberos
#
# [Remember: No empty lines between comments and class definition]
class kerberos (
  $ensure           = 'present',
  $package          = $::kerberos::params::package,
  $config_file      = $::kerberos::params::config_file,
  $default_realm    = $::kerberos::params::default_realm,
  $krb4_config      = $::kerberos::params::krb4_config,
  $krb4_realms      = $::kerberos::params::krb4_realms,
  $krb4_convert     = false,
  $krb4_get_tickets = false,
  $krb5_get_tickets = true,
  $krb_run_aklog    = false,
  $aklog_path       = undef,
  $kdc_timesync     = '1',
  $ccache_type      = '4',
  $forwardable      = false,
  $proxiable        = false,
  $rdns             = true
) inherits kerberos::params {

  validate_bool(
    $krb4_convert,
    $krb4_get_tickets,
    $krb5_get_tickets,
    $krb_run_aklog,
    $forwardable,
    $proxiable,
    $rdns
  )

  case $ensure {
    'present': {
      $package_ensure = 'installed'
      $file_ensure    = 'file'
      $concat_ensure  = 'present'
      $dir_ensure     = 'directory'
    }
    'latest': {
      $package_ensure = 'latest'
      $file_ensure    = 'file'
      $concat_ensure  = 'present'
      $dir_ensure     = 'directory'
    }
    default: {
      $package_ensure = 'absent'
      $file_ensure    = 'absent'
      $concat_ensure  = 'absent'
      $dir_ensure     = 'absent'
    }
  }

  package { $package:
    ensure => $package_ensure,
  }

  concat { 'krb5_config':
    ensure         => $concat_ensure,
    path           => $config_file,
    warn           => '# This file is managed by Puppet, changes may be overwritten.',
    force          => true,
    ensure_newline => false,
    owner          => 'root',
    group          => 'root',
    mode           => '0644',
    require        => Package[$package]
  }

  concat::fragment{'krb5_libdefaults':
    target  => 'krb5_config',
    content => template('kerberos/krb5.conf.fragments/libdefaults.erb'),
    order   => '00AAA'
  }

  concat::fragment{'krb5_logging':
    target  => 'krb5_config',
    content => template('kerberos/krb5.conf.fragments/logging.erb'),
    order   => '02AAA'
  }

  concat::fragment{'krb5_login':
    target  => 'krb5_config',
    content => template('kerberos/krb5.conf.fragments/login.erb'),
    order   => '03AAA'
  }

  concat::fragment{'krb5_realms':
    target  => 'krb5_config',
    content => template('kerberos/krb5.conf.fragments/realms.erb'),
    order   => '04AAA'
  }

  concat::fragment{'krb5_domain_realm':
    target  => 'krb5_config',
    content => template('kerberos/krb5.conf.fragments/domain_realm.erb'),
    order   => '05AAA'
  }

}
