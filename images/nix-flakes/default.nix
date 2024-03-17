{ nix
  #, nixFlakes
, writeTextFile
, extraContents ? [ ]
}:
{
  flakeOverride = nix.override {
    #nix = nixFlakes;
    extraContents = [
      (writeTextFile {
        name = "nix.conf";
        destination = "/etc/nix/nix.conf";
        text = ''
          accept-flake-config = true
          experimental-features = nix-command flakes
        '';
      })
    ] ++ extraContents;
  };
}
