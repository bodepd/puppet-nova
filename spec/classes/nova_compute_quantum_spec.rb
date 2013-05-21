require 'spec_helper'
describe 'nova::compute::quantum' do

  let :facts do
    { :osfamily => 'Debian' }
  end

  let :pre_condition do
    "include nova\ninclude nova::compute\ninclude nova::compute::libvirt"
  end

  it 'should make default configurations' do
    should contain_nova_config('DEFAULT/libvirt_use_virtio_for_bridges').with_value('True')
    should contain_nova_config('DEFAULT/libvirt_vif_driver').with_value('nova.virt.libvirt.vif.LibvirtOpenVswitchDriver')
    should contain_package('libvirt').with_before('File_line[qemu_permissions_update]')
    should contain_file_line('qemu_permissions_update').with(
      :ensure => 'present',
      :line   => 'cgroup_device_acl = ["/dev/null", "/dev/full", "/dev/zero", "/dev/random", "/dev/urandom", "/dev/ptmx", "/dev/kvm", "/dev/kqemu", "/dev/rtc", "/dev/hpet", "/dev/net/tun",]',
      :path   => '/etc/libvirt/qemu.conf',
      :notify => 'Service[libvirt]'
    )
  end

  context 'when setting libvirt_vif_driver' do
    let :params do
      {:libvirt_vif_driver => 'foo' }
    end
    it 'should configure that driver' do
      should contain_nova_config('DEFAULT/libvirt_vif_driver').with_value('foo')
      should_not contain_file_line('qemu_permissions_update')
    end
  end

end
