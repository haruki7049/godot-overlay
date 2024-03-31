self: super:
{
  godot-mono-bin = {
    "3.5.1" = super.stdenv.mkDerivation rec {
      pname = "godot-mono-bin";
      version = "3.5.1";

      src = super.fetchzip {
        url = "https://downloads.tuxfamily.org/godotengine/${version}/mono/Godot_v${version}-stable_mono_x11_64.zip";
        hash = "sha256-2aNeiR/bktqr2LDN9TWr67LDB0ai9S0XKfexmTb0TQg=";
      };

      nativeBuildInputs = [ super.autoPatchelfHook super.makeWrapper super.unzip ];

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

      libraries = super.lib.makeLibraryPath buildInputs;

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

    "4.2.1" = super.stdenv.mkDerivation rec {
      pname = "godot-mono-bin";
      version = "4.2.1";

      src = super.fetchzip {
        url = "https://downloads.tuxfamily.org/godotengine/${version}/mono/Godot_v${version}-stable_mono_linux_x86_64.zip";
        hash = "sha256-OohkRD3vlUGShzFs9TzbSdOJN5zuaOdRIZJ5UdcEm2Q=";
      };

      nativeBuildInputs = [ super.autoPatchelfHook super.makeWrapper super.unzip ];

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

      libraries = super.lib.makeLibraryPath buildInputs;

      installPhase = ''
        mkdir -p $out/bin $out/opt/godot-mono

        install -m 0755 Godot_v${version}-stable_mono_linux.x86_64 $out/opt/godot-mono/Godot_v${version}-stable_mono_linux.x86_64
        cp -r GodotSharp $out/opt/godot-mono

        ln -s $out/opt/godot-mono/Godot_v${version}-stable_mono_x11.64 $out/bin/${pname}-${version}
      '';

      postFixup = ''
        wrapProgram $out/bin/${pname}-${version} \
          --set LD_LIBRARY_PATH ${libraries}
      '';
    };
  };
}
