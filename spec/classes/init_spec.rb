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
    end
  end

  context 'on a RedHat OS' do
    let :facts do
      {
        :osfamily       => 'RedHat',
        :concat_basedir => '/dne',
      }
    end
    it { should raise_error(Puppet::Error, /The kerberos Puppet module does not support RedHat family of operating systems/) }
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
