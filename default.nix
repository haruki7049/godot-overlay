{ pkgs ? import <nixpkgs> { }, system ? builtins.currentSystem, version }:
let inherit (pkgs) callPackage;
in rec {
  godot = callPackage ./overlays/godot { inherit version; };
  #godotHeadless = callPackage ./overlays/godotHeadless { godotBin = godot; };
  #godotMono = callPackage ./overlays/godotMono { godotBin = godot; };
}
