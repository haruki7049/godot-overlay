{ pkgs ? import <nixpkgs> { }, version, system }:

let qualifier = "stable";

in version:
pkgs.stdenv.mkDerivation rec {
  pname = "godot-bin";

  src = pkgs.fetchzip {
    url =
      "https://downloads.tuxfamily.org/godotengine/${version}/Godot_v${version}-${qualifier}_x11.64.zip";
    sha256 = "kl5HGjL2mjxWktfubJXan/l7bmZu562VmD8iO6rQ4H0=";
  };

  nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper pkgs.unzip ];

  buildInputs = [
    pkgs.udev
    pkgs.alsaLib
    pkgs.libXcursor
    pkgs.libXinerama
    pkgs.libXrandr
    pkgs.libXrender
    pkgs.libX11
    pkgs.libXi
    pkgs.libpulseaudio
    pkgs.libGL
  ];

  libraries = pkgs.makeLibraryPath buildInputs;

  unpackCmd = "unzip $curSrc -d source";
  installPhase = ''
    mkdir -p $out/bin
    install -m 0755 Godot_v${version}-${qualifier}_x11.64 $out/bin/godot-${version}
  '';

  postFixup = ''
    wrapProgram $out/bin/godot \
      --set LD_LIBRARY_PATH ${libraries}
  '';

  meta = {
    homepage = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine";
    license = pkgs.licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = [ pkgs.maintainers.haruki7049 ];
  };
}
