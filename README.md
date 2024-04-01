# godot-overlay
A Godot-engine overlay for Nix package manager.

# Usage

```nix
# example/shell-nix/shell.nix
let
  godot_overlay = import (builtins.fetchTarball "https://github.com/haruki7049/godot-overlay/archive/a5606dd90455212059c58f79973a356bf6b80627.tar.gz");
  godotVersion = "4.2.1";
  pkgs = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/057f9aecfb71c4437d2b27d3323df7f93c010b7e.tar.gz") { overlays = [ godot_overlay ]; };
in
pkgs.mkShell {
  packages = with pkgs; [
    godot-bin.mono.${godotVersion}
    dotnet-sdk
  ];
}
```
```nix
# example/nix-flake/flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.11";
    godot-overlay.url = "github:haruki7049/godot-overlay";
  };

  outputs = { self, nixpkgs, godot-overlay }:
    let
      overlays = [
        (import godot-overlay)
      ];
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        inherit overlays;
      };
    in
    {
      devShells."x86_64-linux".default = pkgs.mkShell {
        packages = with pkgs; [
          godot-bin.mono."4.2.1"
          dotnet-sdk
        ];

        shellHook = ''
          export PS1="\n[nix-shell:\w]$ "
        '';
      };
    };
}
```

## A list of versions this overlay can support
- mono
    - 3.5.1
    - 3.5.3
    - 4.2.1
