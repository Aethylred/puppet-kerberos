require 'spec_helper'
describe 'kerberos', :type => :class do
  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily       => 'Debian',
        :concat_basedir => '/dne',
      }
    end
    describe 'with no parameters' do
      it { should contain_class('kerberos::params') }
      it { should contain_package('krb5-user').with_ensure('installed') }
      it { should contain_concat('krb5_config').with(
        'ensure'         => 'present',
        'path'           => '/etc/krb5.conf',
        'warn'           => '# This file is managed by Puppet, changes may be overwritten.',
        'force'          => true,
        'ensure_newline' => false,
        'owner'          => 'root',
        'group'          => 'root',
        'mode'           => '0644',
        'require'        => 'Package[krb5-user]'
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with(
        'target' => 'krb5_config',
        'order'  => '00AAA'
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^\[libdefaults\]$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^# The following krb5.conf variables are only for MIT Kerberos.$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  default_realm = LOCAL$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  krb4_config   = /etc/krb.conf$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  krb4_realms   = /etc/krb.realms$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  kdc_timesync  = 1$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  ccache_type   = 4$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  forwardable   = false$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  proxiable     = false$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  rdns          = true$}
      ) }
      it { should contain_concat__fragment('krb5_logging').with(
        'target' => 'krb5_config',
        'order'  => '02AAA'
      ) }
      it { should contain_concat__fragment('krb5_logging').with_content(
        %r{^\[logging\]$}
      ) }
      it { should contain_concat__fragment('krb5_login').with(
        'target' => 'krb5_config',
        'order'  => '03AAA'
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^\[login\]$}
      ) }
      it { should contain_concat__fragment('krb5_login').without_content(
        %r{^  aklog_path      = .*$}
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  krb4_convert     = false$}
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  krb4_get_tickets = false$}
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  krb5_get_tickets = true$}
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  krb_run_aklog   = false$}
      ) }
      it { should contain_concat__fragment('krb5_realms').with(
        'target' => 'krb5_config',
        'order'  => '04AAA'
      ) }
      it { should contain_concat__fragment('krb5_realms').with_content(
        %r{^\[realms\]$}
      ) }
      it { should contain_concat__fragment('krb5_domain_realm').with(
        'target' => 'krb5_config',
        'order'  => '05AAA'
      ) }
      it { should contain_concat__fragment('krb5_domain_realm').with_content(
        %r{^\[domain_realm\]$}
      ) }
    end
    describe 'when ensure is absent' do
      let :params do
        {
          :ensure => 'absent',
        }
      end
      it { should contain_class('kerberos::params') }
      it { should contain_package('krb5-user').with_ensure('absent') }
      it { should contain_concat('krb5_config').with(
        'ensure'  => 'absent',
        'require' => 'Package[krb5-user]'
      ) }
    end
    describe 'when ensure is latest' do
      let :params do
        {
          :ensure => 'latest',
        }
      end
      it { should contain_class('kerberos::params') }
      it { should contain_package('krb5-user').with_ensure('latest') }
      it { should contain_concat('krb5_config').with(
        'ensure'  => 'present',
        'require' => 'Package[krb5-user]'
      ) }
    end
    describe 'when customising the installation' do
      let :params do
        {
          :package     => 'magic-krb5',
          :config_file => '/this/is/a/bad.idea'
        }
      end
      it { should contain_package('magic-krb5') }
      it { should contain_concat('krb5_config').with(
        'path'    => '/this/is/a/bad.idea',
        'require' => 'Package[magic-krb5]'
      ) }
    end
    describe 'when customising the libdefaults settings' do
      let :params do
        {
          :default_realm => 'example.org',
          :krb4_config   => '/this/is/a/bad.idea',
          :krb4_realms   => '/this/is/a/bad.idea.too',
          :kdc_timesync  => '66',
          :ccache_type   => '1',
          :forwardable   => true,
          :proxiable     => true,
          :rdns          => false,
        }
      end
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  default_realm = example.org$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  krb4_config   = /this/is/a/bad.idea$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  krb4_realms   = /this/is/a/bad.idea.too$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  kdc_timesync  = 66$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  ccache_type   = 1$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  forwardable   = true$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  proxiable     = true$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  rdns          = false$}
      ) }
    end
    describe 'when customising the login settings' do
      let :params do
        {
          :krb4_convert     => true,
          :krb4_get_tickets => true,
          :krb5_get_tickets => false,
          :krb_run_aklog    => true,
          :aklog_path       => '/path/to/bin/aklog.sh',
        }
      end
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  aklog_path      = /path/to/bin/aklog.sh$}
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  krb4_convert     = true$}
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  krb4_get_tickets = true$}
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  krb5_get_tickets = false$}
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  krb_run_aklog   = true$}
      ) }
    end
  end

  context 'on a RedHat OS' do
    let :facts do
      {
        :osfamily       => 'RedHat',
        :concat_basedir => '/dne',
      }
    end
    describe 'with no parameters' do
      it { should contain_class('kerberos::params') }
      it { should contain_package('krb5-libs').with_ensure('installed') }
      it { should contain_package('krb5-workstation').with_ensure('installed') }
      it { should contain_concat('krb5_config').with(
        'ensure'         => 'present',
        'path'           => '/etc/krb5.conf',
        'warn'           => '# This file is managed by Puppet, changes may be overwritten.',
        'force'          => true,
        'ensure_newline' => false,
        'owner'          => 'root',
        'group'          => 'root',
        'mode'           => '0644',
        'require'        => ['Package[krb5-libs]','Package[krb5-workstation]']
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with(
        'target' => 'krb5_config',
        'order'  => '00AAA'
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^\[libdefaults\]$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^# The following krb5.conf variables are only for MIT Kerberos.$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  default_realm = LOCAL$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  krb4_config   = /etc/krb.conf$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  krb4_realms   = /etc/krb.realms$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  kdc_timesync  = 1$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  ccache_type   = 4$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  forwardable   = false$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  proxiable     = false$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  rdns          = true$}
      ) }
      it { should contain_concat__fragment('krb5_logging').with(
        'target' => 'krb5_config',
        'order'  => '02AAA'
      ) }
      it { should contain_concat__fragment('krb5_logging').with_content(
        %r{^\[logging\]$}
      ) }
      it { should contain_concat__fragment('krb5_login').with(
        'target' => 'krb5_config',
        'order'  => '03AAA'
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^\[login\]$}
      ) }
      it { should contain_concat__fragment('krb5_login').without_content(
        %r{^  aklog_path      = .*$}
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  krb4_convert     = false$}
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  krb4_get_tickets = false$}
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  krb5_get_tickets = true$}
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  krb_run_aklog   = false$}
      ) }
    end
    describe 'when ensure is absent' do
      let :params do
        {
          :ensure => 'absent',
        }
      end
      it { should contain_class('kerberos::params') }
      it { should contain_package('krb5-libs').with_ensure('absent') }
      it { should contain_package('krb5-workstation').with_ensure('absent') }
      it { should contain_concat('krb5_config').with(
        'ensure'  => 'absent',
        'require' => ['Package[krb5-libs]','Package[krb5-workstation]']
      ) }
    end
    describe 'when ensure is latest' do
      let :params do
        {
          :ensure => 'latest',
        }
      end
      it { should contain_class('kerberos::params') }
      it { should contain_package('krb5-libs').with_ensure('latest') }
      it { should contain_package('krb5-workstation').with_ensure('latest') }
      it { should contain_concat('krb5_config').with(
        'ensure'  => 'present',
        'require' => ['Package[krb5-libs]','Package[krb5-workstation]']
      ) }
    end
    describe 'when customising the installation' do
      let :params do
        {
          :package     => 'magic-krb5',
          :config_file => '/this/is/a/bad.idea'
        }
      end
      it { should contain_package('magic-krb5') }
      it { should contain_concat('krb5_config').with(
        'path'    => '/this/is/a/bad.idea',
        'require' => 'Package[magic-krb5]'
      ) }
    end
    describe 'when customising the libdefaults settings' do
      let :params do
        {
          :default_realm => 'example.org',
          :krb4_config   => '/this/is/a/bad.idea',
          :krb4_realms   => '/this/is/a/bad.idea.too',
          :kdc_timesync  => '66',
          :ccache_type   => '1',
          :forwardable   => true,
          :proxiable     => true,
          :rdns          => false,
        }
      end
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  default_realm = example.org$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  krb4_config   = /this/is/a/bad.idea$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  krb4_realms   = /this/is/a/bad.idea.too$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  kdc_timesync  = 66$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  ccache_type   = 1$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  forwardable   = true$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  proxiable     = true$}
      ) }
      it { should contain_concat__fragment('krb5_libdefaults').with_content(
        %r{^  rdns          = false$}
      ) }
    end
    describe 'when customising the login settings' do
      let :params do
        {
          :krb4_convert     => true,
          :krb4_get_tickets => true,
          :krb5_get_tickets => false,
          :krb_run_aklog    => true,
          :aklog_path       => '/path/to/bin/aklog.sh',
        }
      end
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  aklog_path      = /path/to/bin/aklog.sh$}
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  krb4_convert     = true$}
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  krb4_get_tickets = true$}
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  krb5_get_tickets = false$}
      ) }
      it { should contain_concat__fragment('krb5_login').with_content(
        %r{^  krb_run_aklog   = true$}
      ) }
    end
  end

  context 'on an Unknown OS' do
    let :facts do
      {
        :osfamily       => 'Unknown',
        :concat_basedir => '/dne',
      }
    end
    it { should raise_error(Puppet::Error, /The kerberos Puppet module does not support Unknown family of operating systems/) }
  end

end
