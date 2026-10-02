{ config, pkgs, ... }: {
  programs.zoxide.enable = true;      # Smarter 'cd'
  programs.bat.enable = true;         # Modern 'cat'
  programs.fd.enable = true;          # Modern 'find'
  programs.ripgrep.enable = true;     # Modern 'grep'

  programs.starship = {               # Modern prompt
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$character";
    };
  };

  programs.fzf = {                    # Fuzzy finder
    enable = true;
    enableZshIntegration = true;
    # pressing Ctrl+T adds live 'bat' preview pane on the right
    fileWidgetOptions = [
      "--preview 'bat --color=always --style=numbers --line-range :500 {}'"
    ];
  };

  programs.eza = {                    # Modern 'ls'
    enable = true;
    icons = "auto";
    git = true;
  };

  home.sessionVariables = {           # Environment Variables
    PAGER = "bat";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    FLAKE = "${config.home.homeDirectory}/nixos-config";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true; 

    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
      share = true;
      ignoreSpace = true;
    };

    shellAliases = {
      vage = "sudo EDITOR=nano nix run github:ryantm/agenix -- -i /etc/ssh/ssh_host_agenix_key -e";
      cat = "bat";
      find = "fd";
      grep = "rg";
      ls = "eza";
      ll = "eza -lh";
      la = "eza -lah";
      tree = "eza --tree";
      nrs = "sudo nixos-rebuild switch --flake $FLAKE#nixos";
      nrt = "sudo nixos-rebuild test --flake $FLAKE#nixos";
    };

    initContent = ''
      # Load the history search widgets
      autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search

      # Bind both normal and application mode arrow keys for Alacritty
      bindkey '^[[A' up-line-or-beginning-search
      bindkey '^[OA' up-line-or-beginning-search
      bindkey '^[[B' down-line-or-beginning-search
      bindkey '^[OB' down-line-or-beginning-search

      # Ctrl + Left/Right arrow to jump whole words
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word
    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.80;
        blur = true;
        padding = { x = 12; y = 12; };
        decorations = "None";
      };
      font = {
        normal = {
          family = "monospace";
          style = "Regular";
        };
      };
      keyboard = {
        bindings = [
          { key = "N"; mods = "Alt"; action = "SpawnNewInstance"; }
        ];
      };
    };
  };
}