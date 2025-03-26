CREATE DATABASE wordpress;

CREATE USER wordpress@localhost IDENTIFIED BY 'pa55w0rd!';

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER 
    ON wordpress.* 
    TO wordpress@localhost;

FLUSH PRIVILEGES;
