self: super:
let
  lib = super.lib;
  stdenv = super.stdenv;
  fetchzip = super.fetchzip;
in
{
  godot-bin = {
    mono =
      let
        mkBinaryInstallV3 = { pname ? "godot-mono-bin", version, url, sha256 }:
          stdenv.mkDerivation rec {
            inherit pname version;

            src = fetchzip {
              inherit url sha256;
            };

            nativeBuildInputs = [
              super.autoPatchelfHook
              super.makeWrapper
              super.unzip
            ];

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
          mkBinaryInstallV4 = { pname ? "godot-mono-bin", version, url, sha256 }:
            stdenv.mkDerivation rec {
              inherit pname version;

              src = fetchzip {
                inherit url sha256;
              };

              nativeBuildInputs = [
                super.autoPatchelfHook
                super.makeWrapper
                super.unzip
              ];

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
                install -m 0755 Godot_v${version}-stable_mono_linux.x86_64 $out/opt/godot-mono/Godot_v${version}-stable_mono_linux.x86_64
                cp -r GodotSharp $out/opt/godot-mono
                ln -s $out/opt/godot-mono/Godot_v${version}-stable_mono_linux.x86_64 $out/bin/${pname}-${version}
              '';

              postFixup = ''
                wrapProgram $out/bin/${pname}-${version} \
                  --set LD_LIBRARY_PATH ${libraries}
              '';
            };
      in
      {
        "3.5.1" = mkBinaryInstallV3 {
          version = "3.5.1";
          url = "https://github.com/godotengine/godot/releases/download/3.5.1-stable/Godot_v3.5.1-stable_mono_x11_64.zip";
          sha256 = "022dyhv9kcgp54bjvxd28q3w7cpbmcszbkdhv2mxm4nv3y4mx8yr";
        };

        "3.5.3" = mkBinaryInstallV3 {
          version = "3.5.3";
          url = "https://github.com/godotengine/godot/releases/download/3.5.3-stable/Godot_v3.5.3-stable_mono_x11_64.zip";
          sha256 = "0lzm8fdk3jzg2ik95hz9yd3qlirckcw2z2zrsdrpsk603vjw3v5b";
        };

        "4.2.1" = mkBinaryInstallV4 {
          version = "4.2.1";
          url = "https://github.com/godotengine/godot/releases/download/4.2.1-stable/Godot_v4.2.1-stable_mono_linux_x86_64.zip";
          sha256 = "0r4v0kbm2ycj458yfs7fkhvqkls9vcygav1ihy9435gg7m26921s";
        };
      };
  };
}
