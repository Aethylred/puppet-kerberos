# Adds a realm definition to krb5.conf
define kerberos::realm (
  $kdc,
  $admin_server   = undef,
  $master_kdc     = undef,
  $default_domain = undef,
  $kpasswd_server = undef
) {

  $upcase_name = upcase($name)
  $order_name = regsubst($name, '\W', '')

  concat::fragment{"krb5_${upcase_name}_realm":
    target  => 'krb5_config',
    content => template('kerberos/krb5.conf.fragments/realm_entry.erb'),
    order   => "04${order_name}"
  }

}
