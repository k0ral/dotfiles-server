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

    # Don't advertise the nginx version number
    server_tokens off;

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
        server_name ${config.networking.domain};
        root /home/http/public;
        access_log /var/log/${config.networking.domain};
        error_log /var/log/${config.networking.domain}.error;
    }

    server {
        listen 7443 ssl;
        listen [::]:7443 ssl;
        server_name kriss.${config.networking.domain};
        root /home/http/kriss/;
        access_log /var/log/kriss;
        error_log /var/log/kriss.error;

        location ~ \.php$ {
            fastcgi_pass unix:/run/phpfpm/phpfpm.sock;
            fastcgi_index index.php;
        }
    }

    server {
        listen 7443 ssl;
        listen [::]:7443 ssl;
        server_name mpd.${config.networking.domain};
        access_log /var/log/mpd;
        error_log /var/log/mpd.error;
        
        location / {
            proxy_pass http://[::1]:8000;
        }
    }

    server {
        listen 7443 ssl;
        listen [::]:7443 ssl;
        server_name shaarli.${config.networking.domain};
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
        server_name zerobin.${config.networking.domain};
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
        server_name gitweb.${config.networking.domain};
        root ${pkgs.git}/share/gitweb/;
        index gitweb.cgi;
        gzip off;
        access_log /var/log/gitweb;
        error_log /var/log/gitweb.error;
        
        include ${pkgs.nginx}/conf/fastcgi_params;
        fastcgi_param GITWEB_CONFIG ${pkgs.writeText "gitweb.conf" ''
          our $projectroot = "/home/git/";
          our @git_base_url_list = qw(git://${config.networking.domain});
          ''};
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
