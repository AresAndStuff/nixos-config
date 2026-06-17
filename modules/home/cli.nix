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
    #pressing Ctrl+T adds live
    #'bat' preview pane on the right
    fileWidgetOptions = [
      "--preview 'bat --color=always --style=numbers --line-range :500 {}'"
    ];
  };

  programs.eza = {                    # Modern 'ls'
    enable = true;
    icons = "auto";
    git = true;
  };

  home.sessionVariables = {           #Environment Variables
    PAGER = "bat";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
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
    };

    initContent = ''
      bindkey '^[[A' history-beginning-search-backward
      bindkey '^[[B' history-beginning-search-forward
    '';
  };

    programs.alacritty = {
  enable = true;
    settings = {
      window = {
        opacity = 0.85;
        padding = { x = 12; y = 12; };
      };
      font = {
        normal = {
          family = "monospace"; # Propo or Mono works best for icon scaling
          style = "Regular";
        };
      };
    };
  };

}