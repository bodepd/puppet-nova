# flat.pp
class nova::network::flat (
  $flat_interface,
  $flat_network_bridge,
  $enabled = "true"
) {

  nova_config  { 'network_manager': value => 'nova.network.manager.FlatManager' }

  # flatManager requires a network bridge be manually setup.
  #if $configure_bridge {
   # nova::network::bridge { $flat_network_bridge:
   #   ip      => $flat_network_bridge_ip,
   #   netmask => $flat_network_bridge_netmask,
   # }
 # }
}
