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
define( 'DB_PASSWORD', 'bananas' );

/** Database hostname */
define( 'DB_HOST', 'localhost' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

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
define('AUTH_KEY',         '>1/n}:97JINrsolvG|tKT%%^]6SK5Av7|!+.z}|@G]GL5vz^5+i*Fy=gQR.X>h2a');
define('SECURE_AUTH_KEY',  ' P>CL4Bi_R##4&r66m(A0-hr]A`)+sG[/^sh)&S`vR2b~3m-QFZj#E2}>)v?!1pA');
define('LOGGED_IN_KEY',    'J/JhOE[ZjeaW K+pg9&V`7DK-:m,d##LYJ,Ml5V;i} JBU6>Re_ZtpFL$DmOBlYo');
define('NONCE_KEY',        '!4g(a#g8C|[4v9euO>og$yaNjW<I+^n&<#]d0]n[,WpmP=pM0|sR902;w%tOCNwN');
define('AUTH_SALT',        '}# D#O?NeiLRpG-/I{]o]b5><bm!SzwDC+dpchh*rxeJMQ,J5^ci[Q7!bmA+}Z&w');
define('SECURE_AUTH_SALT', '_uXRr-f+[WBXcdrmUI(^;}n+tEd7[2R0M6b-o9xHGQb4 wN3`<ephdvm_7!`Cv3v');
define('LOGGED_IN_SALT',   '57V$:$*J?#tzv^zudMdLt2RD$%]Ea|)|ar3!h6%z^*cI`Y-ZDgz(@VXs}q~(!84P');
define('NONCE_SALT',       '@WfB )SDQT`K}Lr%<%zzL `a}Y#g0dV&>zd^+(p-gs|Ro=/0j, %k<Xe|PK;!z;t');

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