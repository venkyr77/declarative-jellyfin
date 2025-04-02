{lib, ...}:
with lib; {
  options.services.declarative-jellyfin.network = {
    BaseUrl = mkOption {
      type = types.str;
    };
    EnableHttps = mkEnableOption "Enable HTTPS";
    RequireHttps = mkEnableOption "Require HTTPS";
    CertificatePath = mkOption {
      type = with types; either str path;
      description = "Path to the certificate file";
    };
    CertificatePassword = mkOption {
      type = types.str;
      description = "Password for the certificate";
    };
    InternalHttpPort = mkOption {
      type = types.port;
      description = "The internal HTTP port jellyfin is run at";
    };
    InternalHttpsPort = mkOption {
      type = types.port;
      description = "The internal HTTPS port jellyfin is run at";
    };
    PublicHttpPort = mkOption {
      type = types.port;
      description = "The public HTTP port jellyfin is run at";
    };
    PublicHttpsPort = mkOption {
      type = types.port;
      description = "The public HTTPS port jellyfin is run at";
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
    LocalNetworkSubnets = mkEnableOption "UNIMPLEMENTED";
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
    PublishedServerUriBySubnet = mkEnableOption "UNIMPLEMENTED";
    RemoteIpFilter = mkOption {
      type = types.str;
      description = "Remote ip filter";
    };
    IsRemoteIPFilterBlacklist = mkEnableOption "Is the remote ip filter list a blacklist or a whitelist";
  };
}
