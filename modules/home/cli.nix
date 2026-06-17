{ config, pkgs, ... }: {
  programs.zoxide.enable = true;      # Smarter 'cd'
  programs.bat.enable = true;         # Modern 'cat'
  programs.fd.enable = true;          # Modern 'find'
  programs.ripgrep.enable = true;     # Modern 'grep'

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = ''
      # Use Alt instead of Ctrl to avoid shell conflicts
      bind-key -n M-t new-window -c "#{pane_current_path}"   # Alt + T = New Tab
      bind-key -n M-w kill-window                             # Alt + W = Close Tab
      bind-key -n M-Left previous-window                      # Alt + Left = Prev Tab
      bind-key -n M-Right next-window                         # Alt + Right = Next Tab

      # Clean, minimal status bar at the bottom
      set -g status-position top
      set -g status-style bg=default,fg=white
      set -g status-left ""
      set -g status-right ""
      set -g window-status-format " #[fg=gray]#I:#W "
      set -g window-status-current-format " #[fg=cyan,bold]#I:#W "
    '';
  };

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
      nrs = "sudo nixos-rebuild switch --flake /home/ado/nixos-config#nixos";
      nrt = "sudo nixos-rebuild test --flake /home/ado/nixos-config#nixos";
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

      # Auto-start tmux for interactive shells
      if [[ -z "$TMUX" && -o interactive ]]; then
          exec tmux
      fi
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