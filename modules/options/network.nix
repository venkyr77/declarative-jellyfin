{lib, ...}:
with lib; {
  options.services.declarative-jellyfin.network = {
    BaseUrl = mkOption {
      type = types.str;
      default = "";
      description = "Add a custom subdirectory to the server URL. For example: http://example.com/<baseurl>";
    };
    EnableHttps = mkEnableOption "Enable HTTPS";
    RequireHttps = mkEnableOption "Require HTTPS";
    CertificatePath = mkOption {
      type = with types; either str path;
      default = "";
      description = "Path to a PKCS #12 file containing a certificate and private key to enable TLS support on a custom domain.";
    };
    CertificatePassword = mkOption {
      type = types.str;
      default = "";
      description = "If your certificate requires a password, please enter it here.";
    };
    InternalHttpPort = mkOption {
      type = types.port;
      default = 8096;
      description = "The TCP port number for the HTTP server.";
    };
    InternalHttpsPort = mkOption {
      type = types.port;
      default = 8920;
      description = "The TCP port number for the HTTPS server.";
    };
    PublicHttpPort = mkOption {
      type = types.port;
      default = 8096;
      description = "The public port number that should be mapped to the local HTTP port.";
    };
    PublicHttpsPort = mkOption {
      type = types.port;
      default = 8920;
      description = "The public port number that should be mapped to the local HTTPS port.";
    };
    AutoDiscovery = mkOption {
      type = types.bool;
      default = true;
      description = "Enable auto discovery";
    };
    EnableUPnP = mkEnableOption "Enable UPnP forwarding";
    EnableIPv4 = mkOption {
      type = types.bool;
      default = true;
      description = "Enable IPv4 routing";
    };
    EnableIPv6 = mkOption {
      type = types.bool;
      default = false;
      description = "Enable IPv6 routing";
    };
    EnableRemoteAccess = mkOption {
      type = types.bool;
      default = true;
      description = "Enable remote access";
    };
    LocalNetworkSubnets = mkOption {
      type = with types; listOf str;
      default = [];
      description = ''
        List of IP addresses or IP/netmask entries for networks that will be considered on local network when enforcing bandwidth restrictions.
        If set, all other IP addresses will be considered to be on the external network and will be subject to the external bandwidth restrictions.
        If left empty, only the server's subnet is considered to be on the local network.
      '';
    };
    LocalNetworkAddresses = mkEnableOption "UNIMPLEMENTED";
    KnownProxies = mkOption {
      type = with types; listOf str;
      description = "A list of known proxies";
      default = [];
    };
    IgnoreVirtualInterfaces = mkOption {
      type = types.bool;
      default = true;
      description = "Ignore virtual interfaces";
    };
    VirtualInterfaceNames = mkOption {
      type = with types; listOf str;
      description = "List of virtual interface names";
      default = ["veth"];
    };
    EnablePublishedServerUriByRequest = mkEnableOption "Enable published server uri by request";
    PublishedServerUriBySubnet = mkOption {
      type = with types; listOf str;
      description = ''
        Override the URI used by Jellyfin, based on the interface, or client IP address.

        For example: `["internal=http://jellyfin.example.com" "external=https://jellyfin.example.com"]` or `["all=https://jellyfin.example.com"]`
      '';
      default = [];
    };
    RemoteIpFilter = mkOption {
      type = with types; listOf str;
      default = [];
      description = ''
        List of IP addresses or IP/netmask entries for networks that will be allowed to connect remotely.
        If left empty, all remote addresses will be allowed.
      '';
    };
    IsRemoteIPFilterBlacklist = mkEnableOption "Is the remote ip filter list a blacklist or a whitelist";
  };
}
