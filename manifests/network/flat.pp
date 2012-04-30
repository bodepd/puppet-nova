# flat.pp
class nova::network::flat (
  $flat_network_bridge,
  $flat_network_bridge_ip,
  $flat_network_bridge_netmask,
  $configure_bridge = true,
  $enabled = "true"
) {

  #class { 'nova::network':
  #  enabled => $enabled,
  #}

  # flatManager requires a network bridge be manually setup.
  if $configure_bridge {
    nova::network::bridge { $flat_network_bridge:
      ip      => $flat_network_bridge_ip,
      netmask => $flat_network_bridge_netmask,
    }
  }
}
