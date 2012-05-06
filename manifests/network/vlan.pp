#vlan.pp
class nova::network::vlan (
  $fixed_range,
  $vlan_interface,
  $public_interface = undef,
  $vlan_start       = '300'
) {

  nova_config {
    'network_manager':  value => 'nova.network.manager.VlanManager';
    'public_interface': value => $public_interface;
    'fixed_range':      value => $fixed_range;
    'vlan_interface':   value => $vlan_interface;
    'vlan_start':       value => $vlan_start;
  }

}
