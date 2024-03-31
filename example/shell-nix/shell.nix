let
  godot_overlay = import (builtins.fetchTarball
    "https://github.com/haruki7049/godot-overlay/archive/a5606dd90455212059c58f79973a356bf6b80627.tar.gz");
  godotVersion = "4.2.1";
  pkgs = import (builtins.fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/057f9aecfb71c4437d2b27d3323df7f93c010b7e.tar.gz") {
      overlays = [ godot_overlay ];
    };
in pkgs.mkShell {
  packages = with pkgs; [ godot-mono-bin.${godotVersion} dotnet-sdk ];
}
