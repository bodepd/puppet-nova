#vlan.pp
class nova::network::vlan (
  $vlan_interface,
  $vlan_start = '100',
  $enabled    = true
) {

  nova_config {
    'network_manager': value => 'nova.network.manager.VlanManager'
    'vlan_interface': value => $vlan_interface
    'vlan_start': $vlan_start,
  }

}
