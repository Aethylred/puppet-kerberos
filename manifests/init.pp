# Class: kerberos
#
# This module manages kerberos
#
# [Remember: No empty lines between comments and class definition]
class kerberos (
  Enum['present', 'latest', 'absent'] $ensure,
  Variant[String, Array[String]] $package,
  Stdlib::Absolutepath $config_file,
  String $default_realm,
  Boolean $dns_lookup_realm,
  Boolean $dns_lookup_kdc,
  Stdlib::Absolutepath $krb4_config,
  Stdlib::Absolutepath $krb4_realms,
  Boolean $krb4_convert,
  Boolean $krb4_get_tickets,
  Boolean $krb5_get_tickets,
  Boolean $krb_run_aklog,
  String $kdc_timesync,
  String $ccache_type,
  Boolean $forwardable,
  Boolean $proxiable,
  Boolean $rdns,
  Optional[Stdlib::Absolutepath] $aklog_path  = undef,
  Optional[String] $ticket_lifetime           = undef,
  Optional[String] $renew_lifetime            = undef
) {

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
