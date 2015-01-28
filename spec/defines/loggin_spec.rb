require 'spec_helper'
describe 'kerberos::logging', :type => :define do
  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily       => 'Debian',
        :concat_basedir => '/dne',
      }
    end
    let :title do
      'test'
    end
    let :pre_condition do
      'include kerberos'
    end
    describe 'with no parameters' do
      it {should contain_concat__fragment('krb5_test_logging').with(
        'target'  => 'krb5_config',
        'content' => "  default = SYSLOG\n",
        'order'   => '02test'
      ) }
    end
    describe 'when key and value of the log' do
      let :params do
        {
          :key => 'kdc',
          :value => 'FILE=/var/log/test_krb5.log'
        }
      end
      it {should contain_concat__fragment('krb5_test_logging').with(
        'target'  => 'krb5_config',
        'content' => "  kdc = FILE=/var/log/test_krb5.log\n",
        'order'   => '02test'
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
      'test'
    end
    let :pre_condition do
      'include kerberos'
    end
    describe 'with no parameters' do
      it {should contain_concat__fragment('krb5_test_logging').with(
        'target'  => 'krb5_config',
        'content' => "  default = SYSLOG\n",
        'order'   => '02test'
      ) }
    end
    describe 'when key and value of the log' do
      let :params do
        {
          :key => 'kdc',
          :value => 'FILE=/var/log/test_krb5.log'
        }
      end
      it {should contain_concat__fragment('krb5_test_logging').with(
        'target'  => 'krb5_config',
        'content' => "  kdc = FILE=/var/log/test_krb5.log\n",
        'order'   => '02test'
      ) }
    end
  end

end
