# This defines a mapping between a domain and a Kerberos realm
define kerberos::domain_realm(
  $realm
) {

  $upcase_realm = upcase($realm)
  $order_name = regsubst($name, '\W', '')

  concat::fragment{"krb5_${name}_domain_realm":
    target  => 'krb5_config',
    content => "  ${name} = ${upcase_realm}\n",
    order   => "05${order_name}",
    require => Kerberos::Realm[$realm],
  }
}