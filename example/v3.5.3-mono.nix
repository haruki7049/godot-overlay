{
  pkgs ? import <nixpkgs> { inherit overlays; },
  overlays ? [ (import ../default.nix) ],
  godotVersion ? "3.5.3",
  mkShell ? pkgs.mkShell,
}:

mkShell {
  packages = [
    pkgs.godot-bin.mono.${godotVersion}
    pkgs.dotnet-sdk
  ];
}
