{ config, lib, pkgs, ... }:

{
    services.nginx.httpConfig = ''
    include ${pkgs.nginx}/conf/mime.types;
    include ${pkgs.nginx}/conf/fastcgi.conf;
    include ${pkgs.nginx}/conf/fastcgi_params;

    default_type application/octet-stream;
    sendfile on;
    keepalive_timeout 65;
    index index.php index.htm index.html;
    autoindex off;

    # SSL
    ssl_certificate /etc/cert.pem;
    ssl_certificate_key /etc/key.pem;
    ssl_session_timeout 5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    # Force HTTPS
    server {
        listen 80;
        listen [::]:80;
        return 301 https://$host$request_uri;
    }

    server {
        listen 7443 default_server ssl;
        listen [::]:7443 default_server ssl;
        server_name twyk.org;
        root /home/http/public;
        access_log /var/log/twyk.org;
        error_log /var/log/twyk.org.error;
    }

    server {
        listen 7443 ssl;
        listen [::]:7443 ssl;
        server_name kriss.twyk.org;
        root /home/http/kriss/;
        access_log /var/log/kriss.twyk.org;
        error_log /var/log/kriss.twyk.org.error;

        location ~ \.php$ {
            fastcgi_pass unix:/run/phpfpm/phpfpm.sock;
            fastcgi_index index.php;
        }
    }

    server {
        listen 7443 ssl;
        listen [::]:7443 ssl;
        server_name mpd.twyk.org;
        access_log /var/log/mpd;
        error_log /var/log/mpd.error;
        
        location / {
            proxy_pass http://[::1]:8000;
        }
    }

    server {
        listen 7443 ssl;
        listen [::]:7443 ssl;
        server_name shaarli.twyk.org;
        root /home/http/shaarli/;
        access_log /var/log/shaarli;
        error_log /var/log/shaarli.error;

        location ~ \.php$ {
            fastcgi_pass unix:/run/phpfpm/phpfpm.sock;
            fastcgi_index index.php;
        }
    }

    server {
        listen 7443 ssl;
        listen [::]:7443 ssl;
        server_name zerobin.twyk.org;
        root /home/http/zerobin/;
        access_log /var/log/zerobin;
        error_log /var/log/zerobin.error;

        location ~ \.php$ {
            fastcgi_pass unix:/run/phpfpm/phpfpm.sock;
            fastcgi_index index.php;
        }
    }

    server {
        listen 7443 ssl;
        listen [::]:7443 ssl;
        server_name gitweb.twyk.org;
        root ${pkgs.git}/share/gitweb/;
        index gitweb.cgi;
        gzip off;
        access_log /var/log/gitweb;
        error_log /var/log/gitweb.error;
        
        include ${pkgs.nginx}/conf/fastcgi_params;
        fastcgi_param GITWEB_CONFIG /etc/gitweb.conf;
        fastcgi_index gitweb.cgi;

        location ~ ".gitweb.cgi" {
            fastcgi_pass unix:/run/fcgiwrap.sock;
        }
    }
    '';

    #services.nginx.gitweb.projectRoot = "/home/git";
    #services.nginx.gitweb.extraNginxConfig = ''
    #  listen 127.0.0.1:443 ssl;
    #  listen [::1]:443 ssl;
    #   '';
}
