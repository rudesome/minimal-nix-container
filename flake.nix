{
  description = "minimal nix container";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      name = "flakes";
      tag = "latest";
    in
    {

      #buildCLIImage = pkgs.callPackage ./lib/buildCLIImage.nix { };
      nix = pkgs.callPackage ./images/nix { };
      flakes = pkgs.callPackage ./images/nix-flakes/default.nix { nix = self.nix; };

      packages.${system} = {
        bare = self.nix;

        default =
          with pkgs.dockerTools;
          buildImage {
            inherit name tag;
            fromImage = self.flakes.flakeOverride;
            copyToRoot =
              with pkgs;
              buildEnv {
                name = "image-${name}";

                paths = [
                  # example app
                  curl
                ];

              };
            config = {
              Cmd = [ "/bin/bash" ];
            };
          };


        devShells.${system}.default =
          with pkgs;
          mkShell
            {
              buildInputs = with pkgs; [
                gnumake
              ];
            };

      };
    };
}
