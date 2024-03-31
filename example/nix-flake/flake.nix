{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.11";
    godot-overlay.url = "github:haruki7049/godot-overlay";
  };

  outputs = { self, nixpkgs, godot-overlay }:
    let
      overlays = [ (import godot-overlay) ];
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        inherit overlays;
      };
    in {
      devShells."x86_64-linux".default = pkgs.mkShell {
        packages = with pkgs; [ godot-mono-bin."4.2.1" dotnet-sdk ];

        shellHook = ''
          export PS1="\n[nix-shell:\w]$ "
        '';
      };
    };
}
