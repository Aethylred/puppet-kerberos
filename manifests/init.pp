# Class: kerberos
#
# This module manages kerberos
#
# [Remember: No empty lines between comments and class definition]
class kerberos (
  Enum['present', 'latest', 'absent'] $ensure = 'present',
  Variant[String, Array[String]] $package     = $::kerberos::params::package,
  Stdlib::Absolutepath $config_file           = $::kerberos::params::config_file,
  String $default_realm                       = $::kerberos::params::default_realm,
  Boolean $dns_lookup_realm                   = false,
  Boolean $dns_lookup_kdc                     = false,
  Stdlib::Absolutepath $krb4_config           = $::kerberos::params::krb4_config,
  Stdlib::Absolutepath $krb4_realms           = $::kerberos::params::krb4_realms,
  Boolean $krb4_convert                       = false,
  Boolean $krb4_get_tickets                   = false,
  Boolean $krb5_get_tickets                   = true,
  Boolean $krb_run_aklog                      = false,
  Optional[Stdlib::Absolutepath] $aklog_path  = undef,
  String $kdc_timesync                        = '1',
  String $ccache_type                         = '4',
  Boolean $forwardable                        = false,
  Boolean $proxiable                          = false,
  Boolean $rdns                               = true,
  Optional[String] $ticket_lifetime           = undef,
  Optional[String] $renew_lifetime            = undef
) inherits kerberos::params {

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
