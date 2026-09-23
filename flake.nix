{
  description = "Custom packages and container images";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pins = builtins.fromJSON (builtins.readFile ./pins.json);
    in
    {
      packages.${system} = {
        caddy = pkgs.callPackage ./pkgs/caddy.nix { inherit pins; };
        tunnel-client = pkgs.callPackage ./pkgs/tunnel-client.nix { inherit pins; };
      };

      checks.${system} = {
        inherit (self.packages.${system}) caddy tunnel-client;
      };

      devShells.${system}.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          curl
          jq
          skopeo
        ];
      };
    };
}
