class mysql {
  package { 'mysql-server':
    ensure => installed,
  }

  # Run startup script for wordpress
  $init_script_path = "${document_root}/wordpressScript.sql"
  file { $init_script_path:
    ensure  => file,
    content => template('mysql/wordpressScript.sql.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }
  exec { 'configure_wordpress_db' :
    command => "mysql -u root < ${init_script_path}",
    path    => ['/usr/bin', '/usr/local/bin'],
    user    => 'root',
    require => [File[$init_script_path], Package['mysql-server']],
  }

  service { 'mysql' :
    ensure     => true,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    name       => 'mysql',
  }
}
