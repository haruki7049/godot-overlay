{ pkgs ? import <nixpkgs> { inherit overlays; }
, overlays ? [ (import ../default.nix) ]
, godotVersion ? "3.5.1"
, mkShell ? pkgs.mkShell
}:

mkShell {
  packages = [
    pkgs.godot-bin.mono.${godotVersion}
    pkgs.dotnet-sdk
  ];
}
