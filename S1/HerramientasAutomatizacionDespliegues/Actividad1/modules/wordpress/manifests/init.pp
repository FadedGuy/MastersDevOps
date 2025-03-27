class wordpress {
  $wp_site_title = 'Generic Title'
  $wp_admin_user = 'admin'
  $wp_admin_password = 'admin'
  $wp_admin_email = 'admin@admin.com'
  $wp_url = 'http://localhost:8080'

  # mkdir and chown
  # sudo mkdir -p /srv/www
  # sudo chown www-data: /srv/www
  file { '/srv/www':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  # curl and unzip
  # curl https://wordpress.org/latest.tar.gz 
  # | sudo -u www-data tar zx -C /srv/www
  exec { 'download_extract_wordpress':
    command => '/usr/bin/curl https://wordpress.org/latest.tar.gz | /bin/tar zx -C /srv/www/',
    path    => ['/usr/bin', '/bin'],
    user    => 'www-data',
    creates => '/srv/www/wordpress',
    require => File['/srv/www'],
  }

  # curl wordpress cli
  exec { 'download_wordpress_cli':
    command => '/usr/bin/curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp',
    path    => ['/bin', '/usr/bin'],
    cwd     => '/usr/local/bin',
    user    => 'root',
    creates => '/usr/local/bin/wp',
  }

  # Configure wordpress db
  file { '/srv/www/wordpress/wp-config.php' :
    ensure  => file,
    content => template('wordpress/wp-config.php.erb'),
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0666',
    require => [Exec['download_extract_wordpress'], Exec['configure_wordpress_db']],
  }

  exec { 'configure_wp_site' :
    # command => 'wp core install  --title="My WordPress Site" --admin_user="admin" --admin_password="your_admin_password" --admin_email="you@example.com" --url="http://localhost:8080"',
    command => "wp core install --title='${wp_site_title}' --admin_user='${wp_admin_user}' --admin_password='${wp_admin_password}' --admin_email='${wp_admin_email}' --url='${wp_url}'",
    path    => ['/usr/local/bin', '/usr/bin'],
    cwd     => '/srv/www/wordpress',
    user    => 'www-data',
    require => [File['/srv/www/wordpress/wp-config.php'], Exec['download_wordpress_cli']],
  }
}
