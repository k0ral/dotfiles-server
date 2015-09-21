# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./bind.zones.nix
    ./hardware-configuration.nix
    ./nginx.conf.nix
    ./private.nix
  ];

  boot.cleanTmpDir = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.supportedFilesystems = [ "zfs" ];

  users.extraUsers.koral = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    #shell = "${pkgs.fish}/bin/fish";
    #passwordFile = "/home/koral/.shadow";
  };
  #users.extraUsers.root.passwordFile = "/etc/.shadow";
  users.mutableUsers = false;

  # i18n.consoleFont = "lat9w-16";
  i18n.consoleKeyMap = "fr";
  # i18n.defaultLocale = "en_US.UTF-8";

  environment.noXlibs = true;
  environment.systemPackages = with pkgs; [
    cacert git grc htop lsof mailutils
  ];
  environment.variables.LS_COLORS = "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:";

  # Network
  networking.hostId = "c35e1759";
  networking.hostName = "adama";
  networking.interfaces.enp2s0.ip4 = [ { address = "192.168.0.2"; prefixLength = 24; } ];
  networking.interfaces.enp2s0.ip6 = [ { address = "2a01:e35:3999:c520::3"; prefixLength = 64; } ];
  networking.defaultGateway = "192.168.0.254";
  networking.domain = "twyk.xyz";
  networking.firewall.enable = false;
  networking.nameservers = [ "208.67.222.222" "208.67.220.220" "8.8.8.8" "8.8.4.4" ];
  networking.tcpcrypt.enable = true;

  # nix
  nix.useChroot = true;

  # nixpkgs
  nixpkgs.config = { 
    packageOverrides = pkgs: {
      v4l_utils = pkgs.v4l_utils.override { withQt4 = false; };
    };
  };

  # atd
  services.atd.enable = true;

  # bind
  services.bind.enable = true;
  services.bind.cacheNetworks = [ "any" ];

  # fcgiwrap
  services.fcgiwrap.enable = true;
  services.fcgiwrap.user = "nginx";
  services.fcgiwrap.group = "nginx";
  services.fcgiwrap.preforkProcesses = 4;

  # folding@home
  services.foldingAtHome.enable = false;
  services.foldingAtHome.nickname = "koral";

  # git-daemon
  services.gitDaemon.enable = true;
  services.gitDaemon.basePath = "/home/git";
  services.gitDaemon.exportAll = true;

  # icecast
  services.icecast.enable = true;
  services.icecast.hostname = "mpd.${config.networking.domain}";
  #services.icecast.admin.password = "";
  services.icecast.extraConf = ''
    <mount type="normal">
      <mount-name>/mpd.ogg</mount-name>
      <username>mpd</username>
      <password>mpd</password>
    </mount>
  '';

  # journald
  services.journald.extraConfig = "SystemMaxUse=50M";

  # mlocate
  services.locate.enable = true;

  # mpd
  services.mpd.enable = true;
  services.mpd.musicDirectory = "/home/music";
  services.mpd.extraConfig = ''
    log_level "verbose"
    restore_paused "no"
    metadata_to_use "artist,album,title,track,name,genre,date,composer,performer,disc,comment"
    
    input {
        plugin "curl"
    }

    audio_output {
      type        "shout"
      encoding    "ogg"
      name        "Icecast stream"
      host        "localhost."
      port        "8000"
      mount       "/mpd.ogg"
      public      "yes"
      bitrate     "192"
      format      "44100:16:1"
      user        "mpd"
      password    "mpd"
    }

    audio_output {
      type "alsa"
      name "fake out"
      driver "null"
    }
  '';

  # nginx
  services.nginx.enable = true;
  #services.nginx.gitweb.enable = true;

  # NSCD
  services.nscd.enable = true;

  # ntp
  services.ntp.enable = true;

  # opensmtpd
  services.opensmtpd.enable = true;
  services.opensmtpd.serverConfiguration = ''
    listen on enp2s0
    table aliases file:/etc/aliases
    accept from any for domain "${config.networking.domain}" alias <aliases> deliver to maildir
    accept for any relay
    '';

  # PHP-FPM
  services.phpfpm.poolConfigs = {
    mypool = ''
      listen = /run/phpfpm/phpfpm.sock
      listen.owner = nginx
      listen.group = nginx
      listen.mode = 0660
      user = nginx
      pm = dynamic
      pm.max_children = 75
      pm.start_servers = 5
      pm.min_spare_servers = 5
      pm.max_spare_servers = 20
      pm.max_requests = 500
      '';
  };

  # Prosody
  services.prosody.enable = true;
  services.prosody.admins = [ "koral@jabber.${config.networking.domain}" ];
  services.prosody.extraConfig = ''
    use_libevent = true
    s2s_require_encryption = true
    c2s_require_encryption = true
    Component "conference.jabber.${config.networking.domain}" "muc"
    Component "proxy.${config.networking.domain}" "proxy65"
    Component "pubsub.${config.networking.domain}" "pubsub"
    '';
  services.prosody.extraModules = [ "private" "vcard" "privacy" "compression" "component" "muc" "pep" "adhoc" "lastactivity" "admin_adhoc" "blocklist"];
  services.prosody.ssl.cert = "/etc/cert.pem";
  services.prosody.ssl.key = "/etc/key.pem";
  services.prosody.virtualHosts.mainHost = {
    domain = "jabber.${config.networking.domain}";
    enabled = true;
  };

  # smartd
  services.smartd.enable = true;
  services.smartd.devices = [ { device = "/dev/sda"; } { device = "/dev/sdb"; } ];
    
  # sslh
  services.sslh.enable = true;
  services.sslh.host = "::";
  # services.sslh.verbose = true;
  services.sslh.appendConfig = ''
    protocols:
    (
      { name: "ssh"; service: "ssh"; host: "localhost."; port: "22"; probe: "builtin"; },
      { name: "openvpn"; host: "localhost."; port: "1194"; probe: "builtin"; },
      { name: "xmpp"; host: "localhost."; port: "5222"; probe: "builtin"; },
      { name: "http"; host: "localhost."; port: "80"; probe: "builtin"; },
      { name: "ssl"; host: "localhost."; port: "7443"; probe: "builtin"; },
      { name: "anyprot"; host: "localhost."; port: "7443"; probe: "builtin"; }
    );
    '';

  # SSH
  services.openssh.enable = true;
  services.openssh.extraConfig = "AllowUsers koral";
  services.openssh.permitRootLogin = "no";
  # services.openssh.startWhenNeeded = true;

  # Tor
  services.tor.enable = true;
  services.tor.relay.enable = true;
  services.tor.relay.isExit = false;
  services.tor.relay.nickname = config.networking.hostName;
  services.tor.relay.portSpec = "110";

  # Transmission
  services.transmission.enable = true;
  services.transmission.settings.blocklist-enabled = true;
  services.transmission.settings.blocklist-url = "http://list.iblocklist.com/?list=bt_level1&fileformat=p2p&archiveformat=gz";
  services.transmission.settings.download-dir = "/home/transmission/";
  services.transmission.settings.rpc-whitelist = "127.0.0.1,192.168.*.*";
  services.transmission.settings.rpc-whitelist-enabled = true;

  # Systemd
  systemd.services.git-update = {
    description = "Update git repositories.";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    startAt = "daily";  
    serviceConfig.Type = "oneshot";

    environment.SSL_CERT_FILE = config.environment.sessionVariables.SSL_CERT_FILE;
    script = ''
      for d in /home/git/*/ ; do
        cd $d && ${pkgs.git}/bin/git fetch --all && ${pkgs.git}/bin/git reset --hard origin/master
      done
      '';
  }; 

}
