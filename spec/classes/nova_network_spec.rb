require 'spec_helper'

describe 'nova::network' do

  let :pre_condition do
    'include nova'
  end

  let :default_params do
    {
      :private_interface => 'eth1',
      :fixed_range       => '10.0.0.0/32',
    }
  end

  let :params do
    default_params
  end

  describe 'on debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end
    it { should contain_sysctl__value('net.ipv4.ip_forward').with_value('1') }
    describe 'when installing service' do
      it { should contain_package('nova-network').with(
        'name'   => 'nova-network',
        'ensure' => 'present',
        'notify' => 'Service[nova-network]'
      ) }
      describe 'with enabled as true' do
        let :params do
          default_params.merge(:enabled => true)
        end
        it { should contain_service('nova-network').with(
          'name'    => 'nova-network',
          'ensure'  => 'running',
          'enable'  => true
        )}
      end
      describe 'when enabled is set to false' do
        it { should contain_service('nova-network').with(
          'name'    => 'nova-network',
          'ensure'  => 'stopped',
          'enable'  => false
        )}
      end
    end
    describe 'when not installing service' do

      let :params do
        default_params.merge(:install_service => false)
      end

      it { should_not contain_package('nova-network') }
      it { should_not contain_service('nova-network') }

    end
  end
  describe 'when creating networks' do
    
  end
  describe 'on rhel' do
    let :facts do
      { :osfamily => 'RedHat' }
    end
    it { should contain_service('nova-network').with(
      'name'    => 'openstack-nova-network',
      'ensure'  => 'stopped',
      'enable'  => false
    )}
    it { should_not contain_package('nova-network') }
  end
end
