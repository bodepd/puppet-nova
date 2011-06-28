class nova::api(
  $enabled = false,
  $export = true
) {

  Exec['post-nova_config'] ~> Service['nova-api']
  Exec['nova-db-sync'] ~> Service['nova-api']

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  exec { "initial-db-sync":
    command     => "/usr/bin/nova-manage db sync",
    refreshonly => true,
    require     => [Package["nova-common"], Nova_config['sql_connection']],
  }

  package { "nova-api":
    ensure  => present,
    require => Package["python-greenlet"],
    notify  => Exec['initial-db-sync'],
  }
  service { "nova-api":
    ensure  => $service_ensure,
    enable  => $enabled,
    require => Package["nova-api"],
    #subscribe => File["/etc/nova/nova.conf"]
  }

  if $export {
    # this can only be used to create a single API server
    @@nova_config { 'api_servers': value => $hostname }
  }
}
