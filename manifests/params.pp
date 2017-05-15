# Class: kerberos::params
#
# This class manages shared prameters and variables for the kerberos module
#
# [Remember: No empty lines between comments and class definition]
class kerberos::params {

# Common values
  $config_file     = '/etc/krb5.conf'
  $default_realm   = 'LOCAL'
  $krb4_config     = '/etc/krb.conf'
  $krb4_realms     = '/etc/krb.realms'
  $includedir_path = undef

# OS specific values
  case $::osfamily {
    'Debian': {
      $package     = 'krb5-user'
    }
    'RedHat': {
        $package     = [
          'krb5-libs',
          'krb5-workstation'
        ]
    }
    default:{
      fail("The kerberos Puppet module does not support ${::osfamily} family of operating systems")
    }
  }
}
