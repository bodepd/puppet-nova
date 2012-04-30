# flatdhcp.pp
class nova::network::flatdhcp (
  $public_interface,
  $flat_interface,
  $flat_dhcp_start,
  $flat_network_bridge_netmask,
  $flat_injected = 'false',
  $dhcpbridge = '/usr/bin/nova-dhcpbridge',
  $dhcpbridge_flagfile='/etc/nova/nova.conf',
  $enabled = 'true'
#fixed_range=10.0.0.0/8
#flat_network_dhcp_start=10.0.0.2
#flat_interface=eth2
#public_interface=eth0
) {
  # we only need to setup configuration, nova does the rest
 # class { 'nova::network':
 #   enabled => $enabled,
 # }

  nova_config {
    'network_manager': value => 'nova.network.manager.FlatDHCPManager';
    'public_interface': value => $public_interface;
    'flat_interface': value => $flat_interface;
    'flat_dhcp_start': value => $flat_dhcp_start;
    'flat_injected': value => $flat_injected;
    'dhcpbridge': value => $dhcpbridge;
    'dhcpbridge_flagfile': value => $dhcpbridge_flagfile;
    'flat_network_bridge_netmask': value => $flat_network_bridge_netmask;
  }

}
