{ lib, stdenv, fetchFromGitHub, kpackage, kwin, nodejs, }:

stdenv.mkDerivation (finalAttrs: {
  pname = "kwin4_effect_geometry_change";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "peterfajdiga";
    repo = "kwin4_effect_geometry_change";
    rev = "v${finalAttrs.version}";
    hash = "sha256-p4FpqagR8Dxi+r9A8W5rGM5ybaBXP0gRKAuzigZ1lyA=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail \
      "kpackagetool6 --type=KWin/Effect -i ./package || kpackagetool6 --type=KWin/Effect -u ./package" \
      ""
  '';

  installPhase = ''
    runHook preInstall

    kpackagetool6 --type=KWin/Effect --install=./package --packageroot=$out/share/kwin/effects

    runHook postInstall
  '';

  nativeBuildInputs = [ kpackage nodejs ];
  buildInputs = [ kwin ];
  dontWrapQtApps = true;

  meta = {
    description =
      "A KWin animation for windows moved or resized by programs or scripts";
    homepage = "https://github.com/peterfajdiga/kwin4_effect_geometry_change";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
  };
})
