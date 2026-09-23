{
  pkgs,
  pins,
}:

let
  pin = pins.tunnelClient;
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "tunnel-client";
  inherit (pin) version;

  src = pkgs.fetchurl {
    url = "https://github.com/${pin.repo}/releases/download/v${pin.version}/tunnel-client-runtime-v${pin.version}-linux-amd64.zip";
    hash = pin.hash;
  };

  nativeBuildInputs = [ pkgs.unzip ];
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    unzip "$src"
    install -Dm755 tunnel-client-runtime "$out/bin/tunnel-client"
    runHook postInstall
  '';

  meta.mainProgram = "tunnel-client";
}
