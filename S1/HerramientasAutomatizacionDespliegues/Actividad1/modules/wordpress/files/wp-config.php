<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wordpress' );

/** Database password */
define( 'DB_PASSWORD', 'pa55w0rd!' );

/** Database hostname */
define( 'DB_HOST', 'localhost' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'QJuoj#Ln7KY/^JA5MgNuDy+3xbR$RA+[}2V!|ISlVF>N]iv^0Gt$5U`9uk(3Pe8:');
define('SECURE_AUTH_KEY',  'k`2,dayLgx.,<jO?6sY;nW_WSRD~e<9-bs[?#.+&VGDWI,k47*;B|=:]~C-:;qFP');
define('LOGGED_IN_KEY',    'TED7j&B,|=DRxz&e,Ft|$4q~V9^_IN)B>|--;m(L:`h?x3[!oB|mo,|A{;jE(`m]');
define('NONCE_KEY',        '=ETS{[khs<pM+_1N1vMQqSusv&rP]>H-~)5cmrQUig=|F?ka.mXWL%)j6s:~% ~5');
define('AUTH_SALT',        '!iQ=S}8F [h5-|FNIsYLQkd+.bD@fd]aN+pw%4[|M)E]I68XZV[|eVpWl|St>Ge$');
define('SECURE_AUTH_SALT', '/lf`3+[=8`ZD$dw+01E<9$pZ+-w3m=pXp*qTTwE#!WfD~FTxc`F&.C~qZNzR$N`k');
define('LOGGED_IN_SALT',   'n-h9.9J8Rx@3Sy4r-mO9+>XWxx(:_<}_ZN?oM^v-E:G,y+L!>a#+mcR0*=bFBr]-');
define('NONCE_SALT',       '~AMBN|}+%8<8<!J*<q]GEJ~n*JD{+r3p3+9rEEL02GQ>Ne)TkB9V-BI>@S2-POl:');

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';