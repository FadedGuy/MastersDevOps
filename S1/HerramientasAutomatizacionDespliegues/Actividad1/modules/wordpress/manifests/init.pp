class wordpress {
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
}
