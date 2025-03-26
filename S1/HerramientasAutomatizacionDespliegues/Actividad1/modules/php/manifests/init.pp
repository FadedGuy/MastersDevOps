class php {
  # Se puede guardar en una variable la lista de dependencias a instalar
  $enhancers = [
    'ghostscript',
    'libapache2-mod-php',
    'php',
    'php-bcmath',
    'php-curl',
    'php-imagick',
    'php-intl',
    'php-json',
    'php-mbstring',
    'php-mysql',
    'php-xml',
    'php-zip',
  ]
  package { $enhancers:
    ensure => installed,
  }
}
