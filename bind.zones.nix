{ config, lib, pkgs, ... }:

let ip4 = "83.153.156.82";
    ip6 = (builtins.elemAt config.networking.interfaces.enp2s0.ip6 0).address;
    domain = config.networking.domain;
    twykZone = ''
    $TTL 7200
    $ORIGIN ${config.networking.domain}.
    @               IN      SOA     ns01.${domain}.  mail.${domain}. (
        2015091101 ; Serial
        28800      ; Refresh
        1800       ; Retry
        604800     ; Expire - 1 week
        86400 )    ; Minimum
    
                    IN      NS      ns01
                    IN      NS      ns02
    
                    IN      MX 10   mail
    
    @               IN      A       ${ip4}
    @               IN      AAAA    ${ip6}
    ;localhost       IN      A       127.0.0.1
    
    mail            IN      A       ${ip4}
    mail            IN      AAAA    ${ip6}
    ns01            IN      A       ${ip4}
    ns01            IN      AAAA    ${ip6}
    ns02            IN      A       ${ip4}
    ns02            IN      AAAA    ${ip6}
    
    imap            IN      CNAME   mail
    smtp            IN      CNAME   mail
    gitweb          IN      CNAME   ${domain}.
    jabber          IN      CNAME   ${domain}.
    kriss           IN      CNAME   ${domain}.
    mpd             IN      CNAME   ${domain}.
    roundcube       IN      CNAME   ${domain}.
    shaarli         IN      CNAME   ${domain}.
    www             IN      CNAME   ${domain}.
    zerobin         IN      CNAME   ${domain}.
    '';
in {
  services.bind.zones = [
  {
    file = pkgs.writeText "${config.networking.domain}.zone" twykZone;
    master = true;
    name = config.networking.domain;
  } ];
}
