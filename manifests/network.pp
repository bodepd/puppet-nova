#
# [private_interface]
# [public_interface]
# [fixed_range]
# [floating_range]
# [enabled]
# [network_manager]
# [network_config]
# [create_networks] Rather actual nova networks should be created using
#   the fixed and floating ranges provided.
#
class nova::network(
  $private_interface,
  $public_interface,
  $fixed_range,
  $floating_range   = false,
  $enabled          = false,
  $network_manager  = 'nova.network.manager.FlatDHCPManager',
  $config_overrides = {},
  $create_networks  = true
) {

  include nova::params

  nova_config {
    'public_interface': value => $public_interface;
    'fixed_range':      value => $fixed_range;
  }

  if $floating_range {
    nova_config { 'floating_range':   value => $floating_range }
  }

  nova::generic_service { 'network':
    enabled      => $enabled,
    package_name => $::nova::params::network_package_name,
    service_name => $::nova::params::network_service_name,
    before       => Exec['networking-refresh']
  }

  if $create_networks {
    nova::manage::network { 'nova-vm-net':
      network       => $fixed_range,
    }
    if $floating_range {
      nova::manage::floating { 'nova-vm-floating':
        network       => $floating_range,
      }
    }
  }

  case $nova::network_manager {

    'nova.network.manager.FlatDHCPManager': {

      $flat_network_bridge = $config_overrides['flat_network_bridge']
      $force_dhcp_release  = $config_overrides['config_dhcp_release']
      $flat_injected       = $config_overrides['flat_injected']
      $dhcpbridge          = $config_overrides['dhcpbridge']
      $dhcpbridge_flagfile = $config_overrides['dhcpbridge_flagfile']

      class { 'nova::network::flatdhcp':
        flat_interface       => $private_interface,
        flat_network_bridge  => $flat_network_bridge,
        force_dhcp_release   => $force_dhcp_release,
        flat_injected        => $flat_injected,
        dhcpbridge           => $dhcpbridge,
        dhcpbridge_flagfile  => $dhcpbridge_flagfile,
      }
    }
    'nova.network.manager.FlatManager': {

      $flat_network_bridge = $config_overrides['flat_network_bridge']

      class { 'nova::network::flat':
        flat_interface       => $private_interface,
        flat_network_bridge  => $flat_network_bridge,
      }
    }
    'nova.network.manager.VlanManager': {
      class { 'nova::network::vlan':
        vlan_interface => $private_interface,
        enabled        => $enabled,
      }
    }
    default: {
      fail("Unsupported network manager: ${nova::network_manager} The supported network managers are nova.network.manager.FlatManager, nova.network.FlatDHCPManager and nova.network.manager.VlanManager")
    }
  }

}
