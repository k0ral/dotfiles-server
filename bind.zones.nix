{ config, lib, pkgs, ... }:

let twykZone = ''
    $TTL 7200
    $ORIGIN twyk.org.
    @               IN      SOA     dns  mail (
        2015020901 ; Serial
        28800      ; Refresh
        1800       ; Retry
        604800     ; Expire - 1 week
        86400 )    ; Minimum
    
    @               IN      NS      dns
    @               IN      MX 10   mail
    @               IN      A       82.235.211.42
    @               IN      AAAA    2a01:e35:2ebd:32a0::2
    ;@               IN      NS      ns.ovh.net
    ;ns02            IN      A       2a01:e35:2ebd:32a0::2
    ;@               IN      TXT     "v=spf1 mx"
    ;localhost       IN      A       127.0.0.1
    
    mail            IN      A       82.235.211.42
    mail            IN      AAAA    2a01:e35:2ebd:32a0::2
    dns             IN      A       82.235.211.42
    dns             IN      AAAA    2a01:e35:2ebd:32a0::2
    ;ns2             IN      A       82.235.211.42
    ;ns2             IN      AAAA    2a01:e35:2ebd:32a0::2
    gitweb          IN      CNAME   twyk.org.
    jabber          IN      CNAME   twyk.org.
    kriss           IN      CNAME   twyk.org.
    mpd             IN      CNAME   twyk.org.
    roundcube       IN      CNAME   twyk.org.
    shaarli         IN      CNAME   twyk.org.
    www             IN      CNAME   twyk.org.
    zerobin         IN      CNAME   twyk.org.
    '';
in {
  services.bind.zones = [
  {
    file = pkgs.writeText "twyk.org.zone" twykZone;
    master = true;
    name = "twyk.org";
  } ];
}
