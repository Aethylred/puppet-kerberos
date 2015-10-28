require 'spec_helper'
describe 'kerberos::realm', :type => :define do
  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily       => 'Debian',
        :concat_basedir => '/dne',
      }
    end
    let :title do
      'example.org'
    end
    let :pre_condition do
      'include kerberos'
    end
    describe 'with no parameters' do
      it { should raise_error(Puppet::Error, /Must pass kdc to Kerberos::Realm\[example.org\]/) }
    end
    describe 'with the minimum kdc server string' do
      let :params do
        {
          :kdc => 'kerberos.example.org',
        }
      end
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with(
        'target'  => 'krb5_config',
        'order'   => '04exampleorg'
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^  EXAMPLE.ORG = \{$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kdc            = kerberos.example.org$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').without_content(
        %r{^    master_kdc     = .*$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').without_content(
        %r{^    admin_server   = .*$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').without_content(
        %r{^    default_domain = .*$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').without_content(
        %r{^    kpasswd_server = .*$}
      ) }
    end
    describe 'with multiple kdc servers' do
      let :params do
        {
          :kdc => [
            'kerberos.example.org',
            'another.krb5.example.org:80',
            'backup.kerberos.example.org'
          ]
        }
      end
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kdc            = kerberos.example.org$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kdc            = another.krb5.example.org:80$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kdc            = backup.kerberos.example.org$}
      ) }
    end
    describe 'with a master kdc server' do
      let :params do
        {
          :kdc        => 'kerberos.example.org',
          :master_kdc => 'master.kerberos.example.org'
        }
      end
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    master_kdc     = master.kerberos.example.org$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kdc            = kerberos.example.org$}
      ) }
    end
    describe 'with an admin server' do
      let :params do
        {
          :kdc          => 'kerberos.example.org',
          :admin_server => 'admin.kerberos.example.org'
        }
      end
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    admin_server   = admin.kerberos.example.org$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kdc            = kerberos.example.org$}
      ) }
    end
    describe 'with a default domain' do
      let :params do
        {
          :kdc            => 'kerberos.example.org',
          :default_domain => 'example.org'
        }
      end
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    default_domain = example.org$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kdc            = kerberos.example.org$}
      ) }
    end
    describe 'with a kpasswd server' do
      let :params do
        {
          :kdc            => 'kerberos.example.org',
          :kpasswd_server => 'example.org'
        }
      end
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kpasswd_server = example.org$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kdc            = kerberos.example.org$}
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
    let :title do
      'example.org'
    end
    let :pre_condition do
      'include kerberos'
    end
    describe 'with no parameters' do
      it { should raise_error(Puppet::Error, /Must pass kdc to Kerberos::Realm\[example.org\]/) }
    end
    describe 'with the minimum kdc server string' do
      let :params do
        {
          :kdc => 'kerberos.example.org',
        }
      end
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with(
        'target'  => 'krb5_config',
        'order'   => '04exampleorg'
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^  EXAMPLE.ORG = \{$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kdc            = kerberos.example.org$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').without_content(
        %r{^    master_kdc     = .*$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').without_content(
        %r{^    admin_server   = .*$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').without_content(
        %r{^    default_domain = .*$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').without_content(
        %r{^    kpasswd_server = .*$}
      ) }
    end
    describe 'with multiple kdc servers' do
      let :params do
        {
          :kdc => [
            'kerberos.example.org',
            'another.krb5.example.org:80',
            'backup.kerberos.example.org'
          ]
        }
      end
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kdc            = kerberos.example.org$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kdc            = another.krb5.example.org:80$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kdc            = backup.kerberos.example.org$}
      ) }
    end
    describe 'with a master kdc server' do
      let :params do
        {
          :kdc        => 'kerberos.example.org',
          :master_kdc => 'master.kerberos.example.org'
        }
      end
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    master_kdc     = master.kerberos.example.org$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kdc            = kerberos.example.org$}
      ) }
    end
    describe 'with an admin server' do
      let :params do
        {
          :kdc          => 'kerberos.example.org',
          :admin_server => 'admin.kerberos.example.org'
        }
      end
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    admin_server   = admin.kerberos.example.org$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kdc            = kerberos.example.org$}
      ) }
    end
    describe 'with a default domain' do
      let :params do
        {
          :kdc            => 'kerberos.example.org',
          :default_domain => 'example.org'
        }
      end
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    default_domain = example.org$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kdc            = kerberos.example.org$}
      ) }
    end
    describe 'with a kpasswd server' do
      let :params do
        {
          :kdc            => 'kerberos.example.org',
          :kpasswd_server => 'example.org'
        }
      end
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kpasswd_server = example.org$}
      ) }
      it {should contain_concat__fragment('krb5_EXAMPLE.ORG_realm').with_content(
        %r{^    kdc            = kerberos.example.org$}
      ) }
    end
  end

end
