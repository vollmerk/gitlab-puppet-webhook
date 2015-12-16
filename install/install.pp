# vim: set softtabstop=2 ts=2 sw=2 expandtab: 

import settings.pp

Exec {
  path  => '/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin/:/bin:/sbin'
}

file { "${basedir}/webhook-puppet.conf":
  ensure  => file,
  mode    => '0640',
  owner   => $runasUser,
  group   => 'root',
  content => template('webhook/webhook-puppet.erb'),
  require => User[$runasUser],
}

file { '/root/openssl.cnf':
  ensure  => file,
  mode    => '0444',
  owner   => 'root',
  group   => 'root',
  content => template('openssl/openssl.erb'),
  before  => Exec['gen-key'],
}

exec { 'gen-deploy-key':
  command => 'ssh-keygen -t rsa -q -N '' -f ${basedir}/git-deploy-key':
  creates => "${basedir}/git-deploy-key",
}

exec { 'gen-key':
  command => "openssl genrsa -out ${basedir}/server.key 4096",
  creates => "${basedir}/server.key",
  user    => 'root',
  before  => Exec['gen-csr'],
}

# Figure out how to supply the info to this
exec { 'gen-csr':
  command => "openssl req -new -key ${basedir}/server.key -out ${basedir}/server.csr -config /root/openssl.cnf -batch",
  creates => "${basedir}/server.csr",
  user    => 'root',
  before  => Exec['gen-crt'],
}

exec { 'gen-crt':
  command => "openssl x509 -req -days 4096 -in ${basedir}/server.csr -signkey ${basedir}/server.key -out ${basedir}/server.crt",
  creates => "${basedir}/server.crt",
  user    => 'root',
  before  => Exec['gen-pem'],
}

exec { 'gen-pem':
  command => "cat ${basedir}/server.crt ${basedir}/server.key > ${basedir}/server.pem",
  creates => "${basedir}/server.pem",
  user    => 'root',
  before  => User[$runasUser],
}

user { $runasUser:
  ensure  => 'present',
}
