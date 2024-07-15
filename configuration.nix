{ config, lib, pkgs, ...}:

{
  boot.cleanTmpDir = true;
  networking.firewall.allowPing = true;
  networking.firewall.logRefusedConnections = false;
  networking.firewall.trustedInterfaces = [ "wg0" ];
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwZnp/BQPN51mLsMyOdGoZ9fEWRsqc/2xo2ZlktHTwiLVUk4R9xeCVUMWUxeTMfYg/DBRjL7TU7o3ItRJwgR6x1bXQHv2czCBDPzohE53AUd+4RdEFRA18/CzRyDRH8nU0NDNFOIWbGsqA+0kQJe7IiftLSwyLcSaL5uXHsDEOj4yBQXVfSOMuP4JqlBpiWDko39LM/+EtKBAaDHEzLqMDGljGb+9YhyxpZAoRMXM1gxayh0l1k924prqB9WXxDQTg3azf3Is3v0fSp2Lk9DygAd9RhVzs1tmv3nmQ5xgiPJXWJPNUwnAapamGCeimzC3GXcWGo7g4x1iBPAzzpWJM1EJt3SyBCAPb8Jlj7YahtAXAzl9oekAWG1Vdx2bTMPWJUnll2UqD8ss6UQcR77w2111IEtI+j+SQskE72DAR8Ai5AUs4kzS6OJXfmJx0nljKJFzZqDs9U2muimF4NhRInkj4KkOqxGj91H6E9KNqVCl2EBZfgO3G6CKCmgcR2fh0/MBI0C/sUwWdvCjWTN1s36wLVs6+gsc5npLkrfhA7mGRyY0PdMleXG78s728HQJjPJg6sG6UL4OW0glGlQAy2rInBfnaCZSH6RulfPEXCY/Q99dwlOtuaFpWxOOj4Jwt/Ua9lQX5+qLIagM9DhIpYPZ/ZIYmdR5CKgmI80iDLQ== babbaj45@gmail.com"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINUDId3QBHhwFC0uxH+0DYkfyJ6tsPt8WuMfshh1KfQb babbaj@soybook.local"
  ];
  system.stateVersion = "22.11";

  users.users.root.shell = pkgs.zsh;

  services.cloud-init.enable = true;

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.ip_forward" = 1;
  networking.firewall.allowedUDPPorts = [ 51820 ];

  # we need to wait until cloud-config runs because it writes the private key
  systemd.services.wireguard-wg0 = {
    after = lib.mkForce [ "cloud-config.target" ];
    wants = lib.mkForce [];
    before = lib.mkForce [];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "192.168.70.1/32" ];
      listenPort = 51820;
      privateKeyFile = "/tmp/wg-private-key";

      peers = [
        { # desktop
          allowedIPs = [ "192.168.70.88/32" ];
          publicKey = "Q8yPJ7BxP796QeSRgBhm12aVbIi/Upyf5NxntH8bC3A=";
        }
        { # iphone
          allowedIPs = [ "192.168.70.89/32" ];
          publicKey = "UIggwyoY/owJCA0hv/8UNPDr2GZ1oHT5ho436Ric+kU=";
        }
        { # macbook
          allowedIPs = [ "192.168.70.90/32" ];
          publicKey = "oZrUn/rkDovRm2lL40j6ojm5J+roSpkYrzalvF5OHVY=";
        }
        { # old phone
          allowedIPs = [ "192.168.70.91/32" ];
          publicKey = "8FpQH1M5vygIPM0jno0upHczJBgL8gue3JgXW2djTgk=";
        }
        {
          allowedIPs = [ "192.168.70.100/32" ];
          publicKey = "Fb0+1EZyDXZD+xKrOsavSO7w+vuPgR2ucPn62dNrBQU=";
        }
      ];
    };
  };
}
