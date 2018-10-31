$traefik_version = '1.5.4'
$traefik_url = "https://github.com/containous/traefik/releases/download/v{${traefik_version}}/traefik_linux-amd64"

notice ("Grabbing traefik ${traefik_version}")

staging::file { '/usr/local/bin/traefik':
  source => $traefik_url,
  target => '/usr/local/bin/traefik',
}
-> exec { 'chmod /usr/local/bin/traefik':
  command => 'chmod 755 /usr/local/bin/traefik',
  path    => ['/sbin','/bin','/usr/sbin','/usr/bin','/usr/local/sbin','/usr/local/bin'],
}

file { '/etc/traefik':
  ensure => directory,
  owner  => root,
  group  => root,
  mode   => '0640',
}

systemd::unit_file { 'traefik.service':
  source => 'puppet:///nubis/files/traefik.systemd',
}
-> service { 'traefik':
  ensure => 'stopped',
  enable => true,
}

file { '/etc/consul/svc-traefik.json':
  ensure => file,
  owner  => root,
  group  => root,
  mode   => '0644',
  source => 'puppet:///nubis/files/svc-traefik.json',
}

# Log rotation
class { '::logrotate':
  manage_cron_daily => false,
  config            => {
    su_user      => 'root',
    su_group     => 'syslog',
    compress     => true,
    rotate_every => 'day',
  },
}

logrotate::rule { 'traefik':
  path       => '/var/log/traefik*.log',
  postrotate => 'systemctl kill -s USR1 traefik.service',
  size       => '256M',
}
