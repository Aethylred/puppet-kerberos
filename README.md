# Kerberos
[![Build Status](https://travis-ci.org/Aethylred/puppet-kerberos.svg?branch=master)](https://travis-ci.org/Aethylred/puppet-kerberos)

This Puppet module manages and installs MIT Kerberos 5 authentication.

# Classes

There is only one class `kerberos`, which manages the installation and configuration of Kerberos.

## `kerberos`

This class installs the Kerberos packages and sets up the base configuration for the other `kerberos` resources to add entries to it.

### Usage

The minimal usage of the `kerberos` class is just to include it in a Puppet manifest which will install it with a default configuration:

```puppet
include kerberos
```

**NOTE:** The Kerberos configuration may not be complete without declaring at least one `kerberos::realm` and at leas one `kerberos::domain_realm` resource.

### Parameters

#### `ensure`

The default is `present` which will install and configure Kerberos. Using `latest` will update the Kerberos packages when they become available. Kerberos packages and configuration will be removed if set to `absent`. Using `ensure` to specify package version is not currently supported.

#### `package`

This specifies a custom package or array of packages. The default is the standard OS specific packages for Kerberos.

#### `config_file`

Specifies the location of the Kerberos configuration file. The default is `/etc/krb5.conf`. Setting this parameter is not recommended, but included to support custom packages.

#### `default_realm`

This sets the default realm for any domain that does not have a specific domain to realm mapping. The default value is `LOCAL`.

#### `krb4_config`

Specifies the location of the Kerberos 4 configuration file. The default is `/etc/krb.conf`. Setting this parameter is not recommended, but included to support custom packages.

#### `krb4_realms`

Specifies the location of the Kerberos 4 realm configuration file. The default is `/etc/krb.realms`. Setting this parameter is not recommended, but included to support custom packages.

#### `krb4_convert`

If set to `true`, Kerberos will convert tickets to version 4. The default value is `false`.

#### `krb4_get_tickets`

If set to `true`, Kerberos will get V4 tickets. The default value is `false`.

#### `krb5_get_tickets`

If set to `true`, Kerberos will get V5 tickets. The default value is `true`.

#### `krb_run_aklog`

If set to `true`, Kerberos will run aklog. The default value is `false`.

#### `aklog_path`

This sets the path to the `aklog` binary or script. The default is undefined which will use the system default.

#### `kdc_timesync`

If set to `1` Kerberos will gather timestamp correction data and correct for synchronisation errors. The default valie is `1`.

#### `ccache_type`

Defines the format of the credential cache. The default value is `4` which is the most current format.

#### `forwardable`

If set to `true` tickets will be forwardable. The default value is `false`.

#### `proxiable`

If set to `true` the principle will be allowed to obtain proxy tickets. The default value is `false`.

#### `rdns`

If this flag is `true`, reverse name lookup will be used in addition to forward name lookup to canonicalizing hostnames for use in service principal names. The default value is `true`.

# Resources

## `kerberos::realm`

This resource defines a realm entry in the `[realms]` section of the Kerberos configuration file as described in the [documentation](http://web.mit.edu/kerberos/krb5-latest/doc/admin/conf_files/krb5_conf.html#realms).

### Usage

The minimal declaration includes just the `kdc` parameter:

```puppet
kerberos::realm{'example.org':
  kdc => kerberos.example.org',
}
```

### Parameters

#### `kdc`

This is a required parameter. This takes a single hostname, or array of hostnames for the servers running `kdc` for a realm. The hostnames may specify a port number suffix separated by a colon (e.g. `kerberos.example.org:80`).

#### `admin_server`

This specifies the hostname for the administration server running `kadmind`. This is usually the master server. The default is undefined.

#### `master_kdc`

This specifies the hostname for the master kdc server. The default is undefined.

#### `default_domain`

This specifies the domain used to expand hostnames. The default is undefined.

## `kerberos::domain_realm`

This resource defines a domain to realm mapping entry in the `[domian_realm]` section of the Kerberos configuration file as described in the [documentation](http://web.mit.edu/kerberos/krb5-latest/doc/admin/conf_files/krb5_conf.html#domain-realm).

### Usage

Each declaration maps the domain used in the `kerberos::domain_realm` declaration to the realm specified by the `realm` parameter:

```puppet
kerberos::domain_realm{'.example.org':
  realm => 'example.org',
}
```

### Parameters

#### `realm`
This is a required parameter. This specifies realm that the domain maps to. The specified domain must be defined as a `kerberos::realm` resource.

## `kerberos::logging`

This resource defines a logging entry in the `[logging]` section of the Kerberos configuration file as described in the [documentation](http://web.mit.edu/kerberos/krb5-latest/doc/admin/conf_files/kdc_conf.html#logging). Multiple entries are permitted allowing logging to the same output to different channels.

### Usage

The minimal usage will set up logging to syslog by default:

```puppet
include kerberos::logging
```

### Parameters

#### `key`

This sets which services are being logged. Only accepts the values `kdc`, `admin_server` or `default`. The default is `default`.

#### `value`

This specifies the destination for the log. Check the [logging documentation](http://web.mit.edu/kerberos/krb5-latest/doc/admin/conf_files/kdc_conf.html#logging) for acceptable values. The default is `SYSLOG`.

# References

* [MIT Kerberos site](http://web.mit.edu/kerberos/)
* [Ivan Bayan krb5 Module](https://forge.puppetlabs.com/IvanBayan/krb5) close but no tests and was not sure about OS logic, or how configuration files were managed.

# Licensing

Copyright 2015 Aaron W. Hicks aethylred@gmail.com

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## puppet-blank

This module is derived from the [puppet-blank](https://github.com/Aethylred/puppet-blank) module by Aaron Hicks (aethylred@gmail.com)

This module has been developed for the use with Open Source Puppet (Apache 2.0 license) for automating server & service deployment.

* http://puppetlabs.com/puppet/puppet-open-source/
