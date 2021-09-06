{ ... }:
{
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."zachlatta.com" = {
      default = true;

      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://slowking:1337";
        proxyWebsockets = true;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Required for automated SSL certificate getting and renewal
  security.acme = {
    email = "zach@zachlatta.com";
    acceptTerms = true;
  };
}