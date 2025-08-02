{
  inputs,
  username,
  host,
  ...
}: {
  imports = [
    ../modules/home
    inputs.kaizen.homeManagerModules.default
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  programs.kaizen.enable = true;
  # home.backupFileExtension = "backup";
  home.username = "ameen";
  home.homeDirectory = "/home/ameen";

  home.stateVersion = "24.11"; # Please read the comment before changing.
  programs.home-manager.enable = true;
}
