{ pkgs, theme, ... }:

let
  # Alt+f in tmux, or `tmux-sessionizer` from any shell: fuzzy-pick a
  # directory and jump to a session named after it, creating it if needed.
  # One session per project, no manual `tmux new -s` bookkeeping.
  sessionizer = pkgs.writeShellApplication {
    name = "tmux-sessionizer";
    runtimeInputs = with pkgs; [
      tmux
      fzf
      fd
      zoxide
      gawk
      coreutils
    ];
    text = ''
      if [ $# -eq 1 ]; then
        selected="$1"
      else
        selected=$(
          {
            printf '%s\n' "$HOME/nixos-config" "$HOME/nix-secrets"
            fd --type d --max-depth 2 . "$HOME/projects" 2>/dev/null || true
            zoxide query -l 2>/dev/null || true
          } | awk '!seen[$0]++' \
            | fzf --prompt="session > " --layout=reverse --border=rounded \
                  --color="bg:${theme.bg},fg:${theme.text},hl:${theme.accent},header:${theme.subtext},bg+:${theme.surface},fg+:${theme.text},marker:${theme.accent}"
        ) || true
      fi

      if [ -z "$selected" ] || [ ! -d "$selected" ]; then
        exit 0
      fi

      name=$(basename "$selected" | tr ' .:' '___')

      if ! tmux has-session -t="$name" 2>/dev/null; then
        tmux new-session -ds "$name" -c "$selected"
      fi

      if [ -n "''${TMUX:-}" ]; then
        tmux switch-client -t "$name"
      else
        tmux attach-session -t "$name"
      fi
    '';
  };
in
{
  home.packages = [ sessionizer ];

  programs.tmux = {
    enable = true;

    prefix = "C-Space"; # C-b is backward-char in zsh; C-Space is free
    baseIndex = 1; # windows start at 1, lines up with Alt+1..9
    escapeTime = 0; # kill the 500ms lag after Esc
    historyLimit = 50000; # default 2000 is nothing
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";
    newSession = true; # `tmux` / `tmux attach` always lands somewhere

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
        '';
      }
    ];

    extraConfig = ''
      # ── behaviour ──────────────────────────────────────────────────
      set -g status-position top
      set -g renumber-windows on        # no holes after closing a window
      set -g detach-on-destroy off      # last window gone -> next session
      set -g set-clipboard on           # OSC52, also works over ssh
      set -g allow-passthrough on
      set -g focus-events on
      set -as terminal-features ",alacritty:RGB"
      setw -g automatic-rename on
      setw -g automatic-rename-format "#{b:pane_current_path}"

      # ── look ───────────────────────────────────────────────────────
      # bg=default keeps alacritty's opacity/blur showing through
      set -g status-style "bg=default,fg=${theme.subtext}"
      set -g status-left " #[fg=${theme.accent}]#{?client_prefix,●,○} #S  "
      set -g status-left-length 30
      set -g status-right ""
      set -g window-status-separator ""
      set -g window-status-format " #[fg=${theme.muted}]#I #W "
      set -g window-status-current-format " #[fg=${theme.accent},bold]#I #W "
      set -g pane-border-style "fg=${theme.surfaceAlt}"
      set -g pane-active-border-style "fg=${theme.accent}"
      set -g message-style "bg=${theme.surface},fg=${theme.text}"
      set -g mode-style "bg=${theme.surfaceAlt},fg=${theme.text}"
      set -g copy-mode-match-style "bg=${theme.accent},fg=${theme.bg}"

      # ── windows (Alt, no prefix) ───────────────────────────────────
      bind-key -n M-t new-window -c "#{pane_current_path}"
      bind-key -n M-w kill-pane              # last pane closes the window
      bind-key -n M-Left  previous-window
      bind-key -n M-Right next-window
      bind-key -n M-1 select-window -t 1
      bind-key -n M-2 select-window -t 2
      bind-key -n M-3 select-window -t 3
      bind-key -n M-4 select-window -t 4
      bind-key -n M-5 select-window -t 5
      bind-key -n M-6 select-window -t 6
      bind-key -n M-7 select-window -t 7
      bind-key -n M-8 select-window -t 8
      bind-key -n M-9 select-window -t 9

      # ── panes ──────────────────────────────────────────────────────
      bind-key -n M-v split-window -h -c "#{pane_current_path}"
      bind-key -n M-s split-window -v -c "#{pane_current_path}"
      bind-key -n M-h select-pane -L
      bind-key -n M-j select-pane -D
      bind-key -n M-k select-pane -U
      bind-key -n M-l select-pane -R
      bind-key -n M-H resize-pane -L 5
      bind-key -n M-J resize-pane -D 5
      bind-key -n M-K resize-pane -U 5
      bind-key -n M-L resize-pane -R 5
      bind-key -n M-z resize-pane -Z
      bind-key -n M-Space next-layout

      # ── sessions ───────────────────────────────────────────────────
      bind-key -n M-f display-popup -E -w 60% -h 60% "tmux-sessionizer"
      bind-key -n M-o choose-tree -Zs
      bind-key -n M-d detach-client

      # ── copy mode ──────────────────────────────────────────────────
      bind-key -n M-Up copy-mode -u
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y \
        send-keys -X copy-pipe-and-cancel "${pkgs.wl-clipboard}/bin/wl-copy"
      bind-key -T copy-mode-vi Escape send-keys -X cancel
      bind-key -T copy-mode-vi MouseDragEnd1Pane \
        send-keys -X copy-pipe-no-clear "${pkgs.wl-clipboard}/bin/wl-copy"

      # ── mouse ──────────────────────────────────────────────────────
      # wheel scrolling is tmux's default since 3.1, only the right-click
      # menus need killing
      unbind -n MouseDown3Pane
      unbind -n MouseDown3Status
      unbind -n MouseDown3StatusLeft

      # ── misc ───────────────────────────────────────────────────────
      bind-key R source-file ~/.config/tmux/tmux.conf \; display "reloaded"
      bind-key -n M-, command-prompt -I "#W" "rename-window '%%'"
    '';
  };
}
