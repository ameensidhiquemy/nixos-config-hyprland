{
  pkgs,
  inputs,
  username,
  host,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";

    extraSpecialArgs = {
      inherit inputs username host;
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "input"
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    packages = [
      inputs.home-manager.packages.${pkgs.system}.default
    ];
  };

  nix.settings.allowed-users = ["${username}"];
  environment.localBinInPath = true;
  networking.nameservers = ["1.1.1.1"];
}
