self: super: 
let
  lib = super.lib;
  stdenv = super.stdenv;
  fetchzip = super.fetchzip;
in {
  godot-bin = {
    mono = let
      mkBinaryInstall = { pname ? "godot-mono-bin", version, url, sha256 }:
        stdenv.mkDerivation rec {
          inherit pname version;

          src = fetchzip {
            inherit url sha256;
          };

          nativeBuildInputs =
            [ super.autoPatchelfHook super.makeWrapper super.unzip ];

          buildInputs = [
            super.udev
            super.alsaLib
            super.xorg.libXcursor
            super.xorg.libXinerama
            super.xorg.libXrandr
            super.xorg.libXrender
            super.xorg.libX11
            super.xorg.libXi
            super.libpulseaudio
            super.libGL
            super.zlib
          ];

          libraries = lib.makeLibraryPath buildInputs;

          installPhase = ''
            mkdir -p $out/bin $out/opt/godot-mono

            install -m 0755 Godot_v${version}-stable_mono_x11.64 $out/opt/godot-mono/Godot_v${version}-stable_mono_x11.64
            cp -r GodotSharp $out/opt/godot-mono

            ln -s $out/opt/godot-mono/Godot_v${version}-stable_mono_x11.64 $out/bin/${pname}-${version}
          '';

          postFixup = ''
            wrapProgram $out/bin/${pname}-${version} \
              --set LD_LIBRARY_PATH ${libraries}
          '';
        };
    in {
    };
  };
}
