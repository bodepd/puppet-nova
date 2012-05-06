# Configuration settings for nova flat network
# ==Parameters
# [flat_interface] Interface that flat network will use for bridging.
# [flat_network_bridge] Name of bridge.
class nova::network::flat (
  $flat_interface,
  $fixed_range,
  $public_interface   = undef,
  $flat_network_bridge = 'br100'
) {

  nova_config {
    'network_manager':     value => 'nova.network.manager.FlatDHCPManager';
    'public_interface':    value => $public_interface;
    'fixed_range':         value => $fixed_range;
    'flat_interface':      value => $flat_interface;
    'flat_network_bridge': value => $flat_network_bridge;
  }

}
