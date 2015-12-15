# vim: set softtabstop=2 ts=2 sw=2 expandtab: 

Exec { 'gen-key':
  command => 'openssl genrsa -out server.key 4096',
  user    => 'root',
  before  => Exec['gen-csr'],
}

# Figure out how to supply the info to this
Exec { 'gen-csr':
  command => 'openssl req -new -key server.key -out server.csr',
  user    => 'root',
  before  => Exec['gen-crt'],
}

Exec { 'gen-crt':
  command => 'openssl x509 -req -days 1024 -in server.csr -signkey server.key -out server.crt',
  user    => 'root',
  before  => Exec['gen-pem'],
}

Exec { 'gen-pem':
  command => 'cat server.crt server.key > server.pem',
  user    => 'root',
  before  => User['webhook'],
}

User { 'webhook':
  ensure  => 'present',
}
