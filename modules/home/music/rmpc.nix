{
  pkgs,
  config,
  theme,
  ...
}:

let
  ytCache = "${config.home.homeDirectory}/Music/discover";

  discover = pkgs.writeShellApplication {
    name = "rmpc-discover";
    runtimeInputs = [
      pkgs.yt-dlp
      pkgs.fzf
      pkgs.rmpc
    ];
    text = ''
      read -r -p "discover > " query
      [[ -z "$query" ]] && exit 0

      selection=$(
        yt-dlp --flat-playlist --no-warnings --ignore-errors \
          --print "%(id)s"$'\t'"%(title)s"$'\t'"%(channel)s"$'\t'"%(duration_string)s" \
          "ytsearch30:$query" \
        | fzf --delimiter=$'\t' --with-nth=2,3,4 --multi \
              --prompt="🎵 > " \
              --header="Space/Tab = select | Enter = stream | Alt+Enter = download" \
              --bind="space:toggle+down" \
              --layout=reverse --border=rounded \
              --color="${theme.fzfColors}" \
              --expect=alt-enter \
        || true
      )

      [[ -z "$selection" ]] && exit 0

      key=$(echo "$selection" | head -n 1)
      items=$(echo "$selection" | tail -n +2)

      [[ -z "$items" ]] && exit 0

      while IFS=$'\t' read -r id _; do
        [[ -z "$id" ]] && continue
        url="https://www.youtube.com/watch?v=$id"

        if [[ "$key" == "alt-enter" ]]; then
          # Download and cache
          rmpc addyt "$url"
        else
          # Stream right away, nothing is saved
          stream_url=$(yt-dlp -g -f bestaudio "$url")
          rmpc add "$stream_url"
        fi
      done <<< "$items"
    '';
  };
in
{
  home.packages = [
    pkgs.yt-dlp
    pkgs.ffmpeg
    discover
  ];

  programs.rmpc = {
    enable = true;
    config = ''
      #![enable(implicit_some)]
      #![enable(unwrap_newtypes)]
      #![enable(unwrap_variant_newtypes)]
      (
        address: "${config.xdg.dataHome}/mpd/socket",
        cache_dir: "${ytCache}",
        theme: "nix",
        volume_step: 5,
        max_fps: 60,
        scrolloff: 4,
        wrap_navigation: true,
        enable_mouse: true,

        album_art: (
          method: Auto,
          max_size_px: (width: 600, height: 600),
          vertical_align: Center,
          horizontal_align: Center,
        ),

        keybinds: (
          global: {
            "1": SwitchToTab("Now"),
            "2": SwitchToTab("Library"),
            "3": SwitchToTab("Search"),
            "4": SwitchToTab("Discover"),
            "y": ExternalCommand(
                   command: ["alacritty", "--class", "rmpc-discover", "-e", "rmpc-discover"],
                   description: "Search YouTube",
                 ),
          },
        ),

        tabs: [
          (
            name: "Now",
            pane: Split(
              direction: Horizontal,
              panes: [
                (size: "35%", pane: Pane(AlbumArt)),
                (size: "65%", pane: Pane(Queue)),
              ],
            ),
          ),
          (
            name: "Library",
            pane: Pane(Artists),
          ),
          (
            name: "Search",
            pane: Pane(Search),
          ),
          (
            name: "Discover",
            pane: Split(
              direction: Horizontal,
              panes: [
                (size: "60%", pane: Pane(Directories)),
                (size: "40%", pane: Pane(AlbumArt)),
              ],
            ),
          ),
        ],
      )
    '';
  };

  xdg.configFile."rmpc/themes/nix.ron".text = ''
    #![enable(implicit_some)]
    #![enable(unwrap_newtypes)]
    #![enable(unwrap_variant_newtypes)]
    (
      layout: Split(
        direction: Vertical,
        panes: [
          (size: "1",    pane: Pane(Tabs)),
          (size: "100%", pane: Pane(TabContent)),
          (size: "2",    pane: Pane(Header)),
          (size: "1",    pane: Pane(ProgressBar)),
        ],
      ),

      background_color: "${theme.bg}",
      text_color: "${theme.text}",
      header_background_color: "${theme.surface}",
      modal_background_color: "${theme.surface}",
      modal_backdrop: true,

      borders_style: (fg: "${theme.surfaceAlt}"),
      highlight_border_style: (fg: "${theme.accent}"),
      current_item_style: (fg: "${theme.accent}", modifiers: "Bold"),
      highlighted_item_style: (fg: "${theme.text}"),
      preview_label_style: (fg: "${theme.subtext}"),
      preview_metadata_group_style: (fg: "${theme.accent}"),

      tab_bar: (
        active_style: (fg: "${theme.accent}", modifiers: "Bold"),
        inactive_style: (fg: "${theme.muted}"),
      ),

      progress_bar: (
        symbols: ["━", "━", "─"],
        track_style: (fg: "${theme.surfaceAlt}"),
        elapsed_style: (fg: "${theme.accent}"),
        thumb_style: (fg: "${theme.accent}"),
      ),

      scrollbar: (
        symbols: ["│", "│", "", ""],
        track_style: (fg: "${theme.bg}"),
        ends_style: (fg: "${theme.bg}"),
        thumb_style: (fg: "${theme.muted}"),
      ),

      symbols: (song: "", dir: "", playlist: "", marker: "", ellipsis: "…"),
      format_tag_separator: " · ",
      browser_column_widths: [25, 40, 35],
    )
  '';
}
