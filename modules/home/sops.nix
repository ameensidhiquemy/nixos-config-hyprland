{ pkgs, ... }: {
  home.packages = with pkgs; [ sops ];
  home.sessionVariables = {
    ANTHROPIC_API_KEY = "dummy-anthropic-key";
    CLAUDE_API_KEY = "dummy-claude-key";
  };
  # imports = [ inputs.sops-nix.nixosModules.sops ];
  # sops = {
  #   age.keyFile = "/home/clementpoiret/.config/sops/age/keys.txt";

  #   secrets."dns/${host}" = {
  #     sopsFile = ../../secrets/secrets.yaml;
  #     owner = config.users.users.clementpoiret.name;
  #   };
  # };
}
