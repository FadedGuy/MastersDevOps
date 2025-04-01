# Variables
$document_root = '/vagrant'

# Database
$db_name = 'wordpress'
$db_user = 'wordpress'
$db_password = 'pa55w0rd!'
$db_host = 'localhost'

# WordPress 
$auth_key = 'QJuoj#Ln7KY/^JA5MgNuDy+3xbR$RA+[}2V!|ISlVF>N]iv^0Gt$5U`9uk(3Pe8:'
$secure_auth_key = 'k`2,dayLgx.,<jO?6sY;nW_WSRD~e<9-bs[?#.+&VGDWI,k47*;B|=:]~C-:;qFP'
$logged_in_key = 'TED7j&B,|=DRxz&e,Ft|$4q~V9^_IN)B>|--;m(L:`h?x3[!oB|mo,|A{;jE(`m]'
$nonce_key = '=ETS{[khs<pM+_1N1vMQqSusv&rP]>H-~)5cmrQUig=|F?ka.mXWL%)j6s:~% ~5'
$auth_salt = '!iQ=S}8F [h5-|FNIsYLQkd+.bD@fd]aN+pw%4[|M)E]I68XZV[|eVpWl|St>Ge$'
$secure_auth_salt = '/lf`3+[=8`ZD$dw+01E<9$pZ+-w3m=pXp*qTTwE#!WfD~FTxc`F&.C~qZNzR$N`k'
$logged_in_salt = 'n-h9.9J8Rx@3Sy4r-mO9+>XWxx(:_<}_ZN?oM^v-E:G,y+L!>a#+mcR0*=bFBr]-'
$nonce_salt = '~AMBN|}+%8<8<!J*<q]GEJ~n*JD{+r3p3+9rEEL02GQ>Ne)TkB9V-BI>@S2-POl:'

$wp_site_title = 'Generic Title'
$wp_admin_user = 'admin'
$wp_admin_password = 'admin'
$wp_admin_email = 'admin@admin.com'
$wp_url = 'http://localhost:8080'

include apache
include mysql
include php
include wordpress

exec { 'apt-update' :
  command => '/usr/bin/apt-get update',
}
# Actualizar los paquetes
Exec['apt-update'] -> Package <| |>
