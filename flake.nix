{
  description = "An overlay for Godot";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.11";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = { self, systems, nixpkgs, flake-utils, treefmt-nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in rec {
        # Use `nix fmt`
        formatter = pkgs.nixfmt;

        packages = import ./default.nix {
          inherit system pkgs;
          version = "3.5.1";
        };

        #apps = rec {
        #  default = apps.godot;
        #  godot = flake-utils.lib.mkApp { drv = packages; };
        #};
        #godotMono = flake-utils.lib.mkApp {
        #  drv = import ./overlays/godotMono { inherit system pkgs; };
        #};
        #godotServer = flake-utils.lib.mkApp {
        #  drv = import ./overlays/godotServer { inherit system pkgs; };
        #};
      });

}
