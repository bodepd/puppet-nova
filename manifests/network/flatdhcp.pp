# flatdhcp.pp
class nova::network::flatdhcp (
  $flat_interface,
  $flat_network_bridge = 'br100',
  $force_dhcp_release  = true,
  $flat_injected       = false,
  $dhcpbridge          = '/usr/bin/nova-dhcpbridge',
  $dhcpbridge_flagfile = '/etc/nova/nova.conf',
  $enabled             = true
) {

  nova_config {
    'network_manager':     value => 'nova.network.manager.FlatDHCPManager';
    'flat_interface':      value => $flat_interface;
    'flat_dhcp_start':     value => $flat_dhcp_start;
    'flat_injected':       value => $flat_injected;
    'dhcpbridge':          value => $dhcpbridge;
    'dhcpbridge_flagfile': value => $dhcpbridge_flagfile;
  }

}
