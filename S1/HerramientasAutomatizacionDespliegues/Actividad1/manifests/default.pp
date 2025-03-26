$document_root = '/vagrant'
include apache
include mysql
include php
include wordpress

# exec { 'Skip Message':
#   command => "echo ‘Este mensaje sólo se muestra si no se ha copiado el fichero index.html'",
#   unless => "test -f ${document_root}/index.html",
#   path => "/bin:/sbin:/usr/bin:/usr/sbin",
# }

exec { 'apt-update' :
  command => '/usr/bin/apt-get update',
}
Exec['apt-update'] -> Package <| |>

$ipv4_address = $facts['networking']['ip']
notify { 'Showing machine Facts':
  message => "Machine with ${facts['memory']['system']['total']} of memory and ${facts['processors']['count']} processor/s.
              Please check access to http://${ipv4_address}",
}
