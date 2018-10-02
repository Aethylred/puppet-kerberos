require 'spec_helper'
describe 'kerberos::domain_realm', :type => :define do
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
      "include kerberos\nkerberos::realm{'example.org': kdc => 'kerberos.example.org'}"
    end
    describe 'with no parameters' do
      it { should_not compile }
    end
    describe 'when setting the realm' do
      let :params do
        {
          :realm => 'example.org',
        }
      end
      it {should contain_concat__fragment('krb5_example.org_domain_realm').with(
        'target'  => 'krb5_config',
        'content' => "  example.org = EXAMPLE.ORG\n",
        'order'   => '05exampleorg'
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
      "include kerberos\nkerberos::realm{'example.org': kdc => 'kerberos.example.org'}"
    end
    describe 'with no parameters' do
      it { should_not compile }
    end
    describe 'when setting the realm' do
      let :params do
        {
          :realm => 'example.org',
        }
      end
      it {should contain_concat__fragment('krb5_example.org_domain_realm').with(
        'target'  => 'krb5_config',
        'content' => "  example.org = EXAMPLE.ORG\n",
        'order'   => '05exampleorg'
      ) }
    end
  end

end
