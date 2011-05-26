<?php
/**
 * SimpleID configuration file.
 *
 * @package simpleid
 *
 */
/*
 * $Id: config.inc.dist 190 2009-09-19 13:41:04Z kmo $
 *
 */


/**
 * Base URL.
 *
 * This is the URL of the location you want to place your SimpleID
 * distribution.  It becomes the URL of the SimpleID server.
 *
 * It is not allowed to have a trailing slash; SimpleID will add it
 * for you.
 *
 * Examples:
 * <code>
 *   define('SIMPLEID_BASE_URL', 'http://www.example.com');
 *   define('SIMPLEID_BASE_URL', 'http://www.example.com:8888');
 *   define('SIMPLEID_BASE_URL', 'http://www.example.com/simpleid');
 *   define('SIMPLEID_BASE_URL', 'https://www.example.com:8888/simpleid');
 * </code>
 *
 */
define('SIMPLEID_BASE_URL', 'http://id.twyk.tk');

/**
 * Directory to store identity information.
 *
 * This directory must exist and be readable by the web server.
 *
 * For maximum security, it is highly recommended to place this
 * directory outside your web browser's document root directory, so
 * that it is not visible to user agents.
 *
 */
define('SIMPLEID_IDENTITIES_DIR', '../identities');

/**
 * Directory to store cache data.
 *
 * This directory must exist and be readable and writable by the
 * web server.
 *
 * For maximum security, it is highly recommended to place this
 * directory outside your web browser's document root directory, so
 * that it is not visible to user agents.
 *
 */
define('SIMPLEID_CACHE_DIR', '../cache');

/**
 * Directory to store persistent data.
 *
 * This directory must exist and be readable and writable by the
 * web server.
 *
 * For maximum security, it is highly recommended to place this
 * directory outside your web browser's document root directory, so
 * that it is not visible to user agents.
 *
 */
define('SIMPLEID_STORE_DIR', '../store');

/**
 * Allows legacy log-in system.
 *
 * Prior to SimpleID 0.6, the login system utilised by SimpleID requires users'
 * passwords to be sent in plaintet to the web server for verification.  This is
 * an inherent security risk.
 *
 * From version 0.6, SimpleID implemented a form of digest authentication, which
 * means that passwords are not sent in plaintext.  For backwards compatibility,
 * and to support browsers that do not have JavaScript installed, the legacy
 * method is still supported if the following configuration parameter is set
 * to true.  Otherwise, users must use a browser which supports JavaScript to
 * log into SimpleID.
 *
 * The default is set to false for security reasons.  You should not change
 * this value unless it is absolutely necessary.
 *
 * @since 0.6
 */
define('SIMPLEID_ALLOW_LEGACY_LOGIN', false);

/**
 * Performs additional verification of relying party return URLs.
 *
 * When authenticating using OpenID version 2, SimpleID version 0.7 or later
 * can perform additional verification of the relying party's return URLs under
 * section 9.2.1 of the OpenID specification.
 *
 * The default is set to true for security reasons.  However, if your web server
 * is blocked by your web hosting provider's firewall from accessing outside
 * servers, then set this to false.
 *
 * @since 0.7
 *
 */
define('SIMPLEID_VERIFY_RETURN_URL_USING_REALM', true);

/**
 * Date and time format.
 *
 * The date and time format specified using the strftime() syntax.
 *
 * See http://www.php.net/strftime for details.
 * 
 */
define('SIMPLEID_DATE_TIME_FORMAT', '%Y-%m-%d %H:%M:%S %Z');

/**
 * The number of seconds before associations expire.  This is an advanced
 * option, for which the default setting should work fine.
 */
define('SIMPLEID_ASSOC_EXPIRES_IN', 3600);

/**
 * SimpleID extensions.
 *
 * The SimpleID extensions you wish to load.  You should separate the
 * extensions you wish to load with a comma.
 *
 */
define('SIMPLEID_EXTENSIONS', 'sreg,ui');

/**
 * Log file.
 *
 * You can specify a file into which SimpleID will log various diagnostic
 * messages.
 *
 * The log file's directory must exist and must be writable by the web server.
 *
 * To disable logging, set this as an empty string.
 *
 */
define('SIMPLEID_LOGFILE', '../log');

/**
 * The level of detail for log messages.
 *
 * You can determine which messages are captured in the log file by specifying
 * a number between 0 and 5. The higher the number, the more messages are
 * logged.
 *
 * WARNING: Setting the log level to 5 will result in security sensitive
 * information also being logged.
 *
 * This has effect only if logging is enabled.
 *
 */
define('SIMPLEID_LOGLEVEL', 4);
?>