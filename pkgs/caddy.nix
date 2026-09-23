{
  pkgs,
  pins,
  hash ? pins.caddy.hash,
}:

let
  caddyPackage =
    let
      caddyWithPlugins = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/caddy-dns/cloudflare@v${pins.caddy.plugins.cloudflare.version}"
          "github.com/relvacode/caddy-oidc@v${pins.caddy.plugins.oidc.version}"
        ];
        inherit hash;
      };
    in
    caddyWithPlugins.overrideAttrs (old: {
      src = old.src.overrideAttrs (_: {
        GOPROXY = "https://goproxy.cn,direct";
      });
    });
in
pkgs.dockerTools.buildLayeredImage {
  name = "custom/caddy";
  tag = "latest";
  contents = [
    caddyPackage
    pkgs.cacert
  ];
  extraCommands = ''
    mkdir -p config data etc/caddy srv
    chmod 0755 config data etc/caddy srv
  '';
  config = {
    Cmd = [
      "${caddyPackage}/bin/caddy"
      "run"
      "--config"
      "/etc/caddy/Caddyfile"
      "--adapter"
      "caddyfile"
    ];
    Env = [
      "XDG_CONFIG_HOME=/config"
      "XDG_DATA_HOME=/data"
    ];
    ExposedPorts = {
      "80/tcp" = { };
      "443/tcp" = { };
      "443/udp" = { };
      "2019/tcp" = { };
    };
    Volumes = {
      "/config" = { };
      "/data" = { };
      "/srv" = { };
    };
    WorkingDir = "/srv";
  };
}
