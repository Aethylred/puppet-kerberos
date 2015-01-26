# Class: kerberos::params
#
# This class manages shared prameters and variables for the kerberos module
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class kerberos::params {

  case $::osfamily {
    Debian:{
      # Do nothing
    }
    default:{
      fail("The kerberos Puppet module does not support ${::osfamily} family of operating systems")
    }
  }
}
