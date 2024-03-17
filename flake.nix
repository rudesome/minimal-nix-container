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
      #buildCLIImage = pkgs.callPackage ./lib/buildCLIImage.nix { };
      nix = pkgs.callPackage ./images/nix { };
      nix-flakes = pkgs.callPackage ./images/nix-flakes/default.nix { inherit nix; };
    in
    {


      packages.${system} = {
        bare = nix-flakes;

        default =
          with pkgs.dockerTools;
          buildImage {
            inherit name tag;
            fromImage = nix-flakes;
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
      };


      devShells.${system}.default =
        with pkgs;
        mkShell
          {
            buildInputs = with pkgs; [
              gnumake
            ];
          };

      devShells."aarch64-darwin".default =
        with pkgs;
        mkShell
          {
            buildInputs = with pkgs; [
              gnumake
            ];
          };
    };
}
