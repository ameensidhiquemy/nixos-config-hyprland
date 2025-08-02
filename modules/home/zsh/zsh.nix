{
  config,
  pkgs,
  ...
}: {
  # Ensure Home Manager is enabled for your user
  # programs.home-manager.enable = true;

  # --- 1. Enable Fish and Basic Settings ---
  programs.fish = {
    enable = true;
    # Optional: Disable the default fish greeting message
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';

    # Set default key bindings (similar to your zsh bindkey)
    # Fish history search is usually Alt+Up/Down by default,
    # but you can rebind if you prefer Ctrl+p/n for *history search*
    # Note: Fish's default Ctrl+p/n are for "previous/next history entry"
    # To mimic zsh's history-search-backward/forward:

    # History settings

    # --- 2. Plugins ---
    # Many Zsh plugins have Fish equivalents or are built-in.
    # We'll replace your Antidote plugins.
    plugins = [
      # a. fast-syntax-highlighting -> fish-syntax-highlighting (built-in)
      # Fish has syntax highlighting built-in and enabled by default,
      # so you don't need a separate plugin for this!

      # b. zsh-autosuggestions -> fish-autosuggestions (built-in)
      # Fish also has autosuggestions built-in and enabled by default,
      # so no separate plugin is needed here either!

      # c. zsh-users/zsh-completions -> Fish's excellent built-in completions
      # Fish's completion system is very powerful. Many common completions are
      # available. For specific tools, you might need to find a Fish completion
      # plugin or generate one.

      # Example: fzf key bindings and completions for Fish (if not already handled by programs.fzf)
      # If `programs.fzf.enableZshIntegration` worked, you'd convert it for fish.
      # `programs.fzf.enableFishIntegration` would be the correct option in home.nix
      # If fzf integration is handled by the `programs.fzf` module, you don't need
      # a separate plugin entry here.

      # If you wanted general utils (like your belak/zsh-utils equivalent):
      # You'll likely implement these as custom Fish functions/aliases
      # rather than a monolithic plugin.

      # If you install `z` for jumping directories, you'll need the Fish version.
      # `programs.zoxide.enableFishIntegration` will handle this.
    ];

    # --- 3. Shell Aliases ---
    # Translate Zsh aliases to Fish aliases.
    # `shellAliases` in Home Manager handles the translation automatically.
    shellAliases = {
      # Utils
      nixos = "bash <(curl -sL https://github.com/suderman/nixos/raw/main/overlays/bin/nixos-cli/nixos)"; # Keep as bash for now
      c = "clear";
      cd = "z"; # This will work if zoxide is enabled for Fish
      tt = "gtrash put";
      cat = "bat";
      py = "python";
      icat = "kitty +kitten icat"; # Corrected for kitty
      dsize = "du -hs";
      findw = "grep -rl";
      pdf = "tdf";
      open = "xdg-open"; # This works fine in Fish

      ls = "lsd --group-directories-first";
      ll = "lsd -l --group-directories-first";
      la = "lsd -la --group-directories-first";
      # Fish functions are better for complex aliases/scripts like tree
      # This will be a function below
      # tree = "lsd -l --group-directories-first --tree --depth=2";

      # Nixos
      cdnix = "cd ~/nixos-config && nvim ~/nixos-config";
      # ns and nix-shell are fish functions/aliases due to `--run zsh`
      # In Fish, you just type `nix-shell` and it drops you into a Fish shell if
      # the shell attribute in the Nix expression is set to fish.
      # If not, you'd use `nix-shell --command fish`
      ns = "nix-shell --command fish"; # Or just `nix-shell` if your nix-shell environment has fish as default
      nix-shell = "nix-shell --command fish";
      # Note: Need to make sure `host` variable is available.
      # If `host` is defined in your Home Manager top-level, it will work.
      # Otherwise, use a static string for `hostname` if it's for one host.
      nix-switchu = "sudo nixos-rebuild switch --upgrade --flake ~/nixos-config#laptop";
      nix-flake-update = "sudo nix flake update ~/nixos-config"; # Removed `#` at the end
      nix-clean = "sudo nix-collect-garbage && sudo nix-collect-garbage -d && sudo rm /nix/var/nix/gcroots/auto/* && nix-collect-garbage && nix-collect-garbage -d";

      # Git (standard aliases work fine)
      ga = "git add";
      gaa = "git add --all";
      gs = "git status";
      gb = "git branch";
      gm = "git merge";
      gpl = "git pull";
      gplo = "git pull origin";
      gps = "git push";
      gpst = "git push --follow-tags";
      gpso = "git push origin";
      gc = "git commit";
      gcm = "git commit -m";
      gcma = "git add --all && git commit -m";
      gtag = "git tag -ma";
      gch = "git checkout";
      gchb = "git checkout -b";
      gcoe = "git config user.email";
      gcon = "git config user.name";

      # python (aliases work)
      piv = "python -m venv .venv";
      psv = "source .venv/bin/activate.fish"; # IMPORTANT: Use .venv/bin/activate.fish

      # custom tools (aliases work)
      lakectl = "/home/clementpoiret/bin/lakectl"; # Ensure this path is correct for your user
      emacs = "emacsclient -c -a 'emacs'";

      # to fix std lib issues
      # This should be a function in Fish if you need to set env vars for one command
      # obsidian = "export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH; obsidian";
    };

    # --- 4. Fish Functions for Complex Aliases/Scripts ---
    # `shellInit` allows you to define custom Fish functions and general setup.
    shellInit = ''
      # micromamba integration
      # This needs to be evaluated in Fish syntax.
      # Find the `micromamba shell init fish` output
      # It's usually something like:
      # ${pkgs.micromamba}/bin/micromamba shell init fish | source
      # or you might need to put the exact lines here.
      # Test `micromamba shell init fish` in a fish shell and copy the output.
      # Example (actual output might vary):
      if test -f "$HOME/.micromamba/bin/micromamba.fish"
          source "$HOME/.micromamba/bin/micromamba.fish"
      end

      # Function for 'tree' alias
      function tree
          lsd -l --group-directories-first --tree --depth=2 $argv
      end

      # Function for 'obsidian' with LD_LIBRARY_PATH fix
      function obsidian
          env LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH obsidian $argv
      end

      # Fish completion for `z` (zoxide) if it's not automatically handled
      # by programs.zoxide.enableFishIntegration
      # if type -q _zoxide_precmd
      #   _zoxide_precmd
      # end
      # status --is-interactive; and source (zoxide --init fish | psub)
    '';
  };

  # --- 5. Oh My Posh Integration for Fish ---
  # Home Manager's `programs.oh-my-posh` module handles Fish integration.
  programs.oh-my-posh = {
    enable = true;
    enableFishIntegration = true; # IMPORTANT: Change from enableZshIntegration
    enableNushellIntegration = false;
    settings = {
      "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
      version = 2;
      final_space = true;
      console_title_template = "{{ .Shell }} in {{ .Folder }}";
      blocks = [
        {
          type = "prompt";
          alignment = "left";
          newline = true;

          segments = [
            {
              type = "path";
              style = "plain";
              background = "transparent";
              foreground = "blue";
              properties.style = "full";
              template = "{{ .Path }}";
            }
            {
              type = "git";
              style = "plain";
              background = "transparent";
              foreground = "p:grey";
              template = " {{ .HEAD }}{{ if or (.Working.Changed) (.Staging.Changed) }}*{{ end }} <cyan>{{ if gt .Behind 0 }}⇣{{ end }}{{ if gt .Ahead 0 }}⇡{{ end }}</>";
              properties = {
                branch_icon = "";
                commit_icon = "@";
                fetch_status = true;
              };
            }
          ];
        }

        {
          type = "rprompt";
          overflow = "hidden";

          segments = [
            {
              type = "executiontime";
              style = "plain";
              background = "transparent";
              foreground = "yellow";
              template = "{{ .FormattedMs }}";
              properties.threshold = 5000;
            }
            {
              type = "python";
              style = "plain";
              background = "transparent";
              foreground = "p:grey";
              fetch_virtual_env = true;
              display_default = true;
              fetch_version = true;
            }
          ];
        }

        {
          type = "prompt";
          alignment = "left";
          newline = true;

          segments = [
            {
              type = "text";
              style = "plain";
              background = "transparent";
              foreground_templates = [
                "{{if gt .Code 0}}red{{end}}"
                "{{if eq .Code 0}}magenta{{end}}"
              ];
              template = "❯";
            }
          ];
        }
      ];

      transient_prompt = {
        background = "transparent";
        foreground_templates = ["{{if gt .Code 0}}red{{end}}" "{{if eq .Code 0}}magenta{{end}}"];
        template = "❯ ";
      };

      secondary_prompt = {
        background = "transparent";
        foreground = "magenta";
        template = "❯❯ ";
      };

      palette.grey = "#6c6c6c";
    };
  };

  # --- 6. Zoxide, FZF, Atuin Integration ---
  # Home Manager's modules for these tools have specific Fish integration options.
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true; # IMPORTANT: Change from enableZshIntegration
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true; # IMPORTANT: Change from enableZshIntegration
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true; # IMPORTANT: Change from enableZshIntegration
  };

  # --- 7. Remove Zsh Configuration ---
  # If you are fully migrating, remove the `programs.zsh` block.
  # If you want to keep Zsh as a fallback, you can leave it, but ensure
  # it's not the default login shell if Fish is.
  # programs.zsh = { ... }; # REMOVE THIS BLOCK if fully migrating
}
