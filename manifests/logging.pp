# This defines logging entries in the Kerberos config
define kerberos::logging (
  Enum['default', 'kdc', 'admin_server'] $key   = 'default',
  String $value                                 = 'SYSLOG'
) {

  validate_re($value, [
    '^FILE[=|:].*$',
    '^STDERR$',
    '^CONSOLE$',
    '^DEVICE=.*$',
    '^SYSLOG(:.*)?$'
  ] )

  $order_name = regsubst($name, '\W', '')

  concat::fragment{"krb5_${name}_logging":
    target  => 'krb5_config',
    content => "  ${key} = ${value}\n",
    order   => "02${order_name}"
  }

}
