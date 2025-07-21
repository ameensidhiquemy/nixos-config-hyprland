{ config, inputs, pkgs, ... }:
let
  home = config.home.homeDirectory;
  token = "dummy-pypi-token";
  pypirc = ''
    [distutils]
    index-servers =
        pypi

    [pypi]
    repository: https://upload.pypi.org/legacy/
    username: __token__
    password: dummy-pypi-token
  '';
in {
  home.file = {
    ".pypirc" = {
      text = pypirc;
    };
  };
}
