include kerberos

kerberos::realm{'example.org':
  kdc          => ['kerberos.example.org','krb5.example.org:80'],
  admin_server => 'master.kerberos.example.org',
}

kerberos::realm{'example.com':
  kdc        => 'kerberos.example.com',
  master_kdc => 'master.kerberos.example.com',
}

kerberos::realm{'example.edu':
  kdc            => 'kerberos.example.edu',
  default_domain => 'example.edu',
}

kerberos::domain_realm{'example.org':
  realm => 'example.org',
}

kerberos::domain_realm{'.example.org':
  realm => 'example.org',
}

kerberos::domain_realm{'test.example.org':
  realm => 'example.org',
}

kerberos::domain_realm{'.test.example.org':
  realm => 'example.org',
}
