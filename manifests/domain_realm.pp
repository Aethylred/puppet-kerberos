# This defines a mapping between a domain and a Kerberos realm
define kerberos::domain_realm(
  $realm
) {

  $upcase_realm = upcase($realm)

  concat::fragment{"krb5_${name}_domain_realm":
    target  => 'krb5_config',
    content => "  ${name} = ${upcase_realm}",
    order   => "05${name}",
    require => Kerberos::Realm[$realm],
  }
}