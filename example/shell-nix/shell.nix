let
  godot_overlay = import (builtins.fetchTarball
    "https://github.com/haruki7049/godot-overlay/archive/65444ac1403370d6d657a5e7edeccec07ff406ef.tar.gz");
  godotVersion = "4.2.1";
  pkgs = import (builtins.fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/057f9aecfb71c4437d2b27d3323df7f93c010b7e.tar.gz") {
      overlays = [ godot_overlay ];
    };
in pkgs.mkShell {
  packages = with pkgs; [ godot-bin.mono.${godotVersion} dotnet-sdk ];
}
