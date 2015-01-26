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
      it { should contain_concat('kerberos_config').with(
        'ensure'         => 'present',
        'path'           => '/etc/krb5.conf',
        'warn'           => '# This file is managed by Puppet, changes may be overwritten.',
        'force'          => true,
        'ensure_newline' => true,
        'owner'          => 'root',
        'group'          => 'root',
        'mode'           => '0644',
        'require'        => 'Package[krb5-user]'
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
      it { should contain_concat('kerberos_config').with(
        'ensure'         => 'absent',
        'require'        => 'Package[krb5-user]'
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
      it { should contain_concat('kerberos_config').with(
        'ensure'         => 'present',
        'require'        => 'Package[krb5-user]'
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
      it { should contain_concat('kerberos_config').with(
        'ensure'         => 'present',
        'path'           => '/etc/krb5.conf',
        'warn'           => '# This file is managed by Puppet, changes may be overwritten.',
        'force'          => true,
        'ensure_newline' => true,
        'owner'          => 'root',
        'group'          => 'root',
        'mode'           => '0644',
        'require'        => ['Package[krb5-libs]','Package[krb5-workstation]']
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
      it { should contain_concat('kerberos_config').with(
        'ensure'         => 'absent',
        'require'        => ['Package[krb5-libs]','Package[krb5-workstation]']
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
      it { should contain_concat('kerberos_config').with(
        'ensure'         => 'present',
        'require'        => ['Package[krb5-libs]','Package[krb5-workstation]']
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
