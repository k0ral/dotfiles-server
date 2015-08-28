{ config, lib, pkgs, ... }:

let twykZone = ''
    $TTL 7200
    $ORIGIN ${config.networking.domain}.
    @               IN      SOA     dns  mail (
        2015082802 ; Serial
        28800      ; Refresh
        1800       ; Retry
        604800     ; Expire - 1 week
        86400 )    ; Minimum
    
    @               IN      NS      ns
    @               IN      MX 10   mail
    @               IN      A       83.153.156.82
    @               IN      AAAA    ${(builtins.elemAt config.networking.interfaces.enp2s0.ip6 0).address}
    ;@               IN      NS      ns.ovh.net
    ;ns02            IN      A       ${(builtins.elemAt config.networking.interfaces.enp2s0.ip6 0).address}
    ;@               IN      TXT     "v=spf1 mx"
    ;localhost       IN      A       127.0.0.1
    
    mail            IN      A       83.153.156.82
    mail            IN      AAAA    ${(builtins.elemAt config.networking.interfaces.enp2s0.ip6 0).address}
    ns              IN      A       83.153.156.82
    ns              IN      AAAA    ${(builtins.elemAt config.networking.interfaces.enp2s0.ip6 0).address}
    ns2             IN      A       83.153.156.82
    ns2             IN      AAAA    ${(builtins.elemAt config.networking.interfaces.enp2s0.ip6 0).address}
    gitweb          IN      CNAME   ${config.networking.domain}.
    jabber          IN      CNAME   ${config.networking.domain}.
    kriss           IN      CNAME   ${config.networking.domain}.
    mpd             IN      CNAME   ${config.networking.domain}.
    roundcube       IN      CNAME   ${config.networking.domain}.
    shaarli         IN      CNAME   ${config.networking.domain}.
    www             IN      CNAME   ${config.networking.domain}.
    zerobin         IN      CNAME   ${config.networking.domain}.
    '';
in {
  services.bind.zones = [
  {
    file = pkgs.writeText "${config.networking.domain}.zone" twykZone;
    master = true;
    name = config.networking.domain;
  } ];
}
