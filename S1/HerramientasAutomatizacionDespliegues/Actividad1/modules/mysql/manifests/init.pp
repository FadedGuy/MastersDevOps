class mysql {
  package { 'mysql-server':
    ensure => installed,
  }

  service { 'mysql-server' :
    ensure    => true,
    enable    => true,
    hasstatus => true,
  }
}
