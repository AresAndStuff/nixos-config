{ theme, ... }:

{
  services.swaync = {
    enable = true;

    settings = {
      positionX                    = "right";
      positionY                    = "top";
      layer                        = "overlay";
      control-center-margin-top    = 12;
      control-center-margin-bottom = 12;
      control-center-margin-right  = 12;
      control-center-margin-left   = 12;
      control-center-width         = 400;
      notification-window-width    = 400;
      transition-time              = 200;
      hide-on-clear                = false;
      hide-on-action                = true;
      keyboard-shortcuts            = true;

      widgets = [
        "title"
        "dnd"
        "volume"
        "mpris"
        "notifications"
      ];

      widget-config = {
        title = {
          text             = "Notifications";
          clear-all-button = true;
          button-text      = "Clear";
        };
        dnd.text     = "Do Not Disturb";
        volume.label = " ";
      };
    };

    style = ''
      @define-color bg          ${theme.bg};
      @define-color surface     ${theme.surface};
      @define-color surface-alt ${theme.surfaceAlt};
      @define-color text        ${theme.text};
      @define-color subtext     ${theme.subtext};
      @define-color muted       ${theme.muted};
      @define-color accent      ${theme.accent};
      @define-color red         ${theme.red};

      * {
        border:        none;
        border-radius: 0;
        font-family:   "${theme.font}", monospace;
        font-size:     15px;
        min-height:    0;
      }

      .control-center {
        background-color: @bg;
        color:             @text;
        border-radius:     6px;
        padding:           8px;
      }

      .control-center scrollbar slider {
        background-color: @muted;
        border-radius:     4px;
        min-width:          4px;
      }
      .control-center scrollbar slider:hover {
        background-color: @accent;
      }

      .widget-title,
      .widget-dnd,
      .widget-volume,
      .widget-mpris {
        background-color: @surface;
        border-radius:     4px;
        padding:           8px 10px;
        margin:            4px 3px 6px;
        color:             @text;
      }

      .widget-title label {
        font-weight: bold;
        color:       @text;
      }
      .widget-title button {
        background-color: @surface-alt;
        color:             @text;
        border-radius:     4px;
        padding:           4px 10px;
        font-size:         13px;
      }
      .widget-title button:hover {
        background-color: @muted;
      }

      .widget-volume label {
        color:        @accent;
        margin-right: 6px;
      }

      .widget-mpris-title {
        font-weight: bold;
        color:       @text;
      }
      .widget-mpris-subtitle {
        color: @subtext;
      }
      .widget-mpris-album-art {
        border-radius: 4px;
        min-width:      48px;
        min-height:     48px;
      }
      .widget-mpris-ctrl-btn {
        background:    transparent;
        color:         @text;
        border-radius: 4px;
        min-width:      28px;
        min-height:     28px;
      }
      .widget-mpris-ctrl-btn:hover {
        background-color: @surface-alt;
      }

      .notification-row {
        margin: 0 0 6px 0;
      }
      .notification {
        background-color: @surface;
        border-radius:     4px;
        padding:           10px 12px;
        transition:        150ms ease;
      }
      .notification:hover {
        background-color: @surface-alt;
      }
      .notification.critical {
        border-left: 3px solid @red;
      }

      .notification .image {
        border-radius: 4px;
      }
      .notification .close-button {
        background-color: @surface-alt;
        color:             @subtext;
        border-radius:     4px;
        min-width:          18px;
        min-height:         18px;
        font-size:         10px;
      }
      .notification .close-button:hover {
        background-color: @red;
        color:             @bg;
      }

      .summary {
        font-weight: bold;
        color:       @text;
        font-size:   14px;
      }
      .body {
        color:      @subtext;
        margin-top: 2px;
        font-size:  13px;
      }
      .time {
        color:     @muted;
        font-size: 11px;
      }

      .notification-action {
        background-color: @surface-alt;
        color:             @text;
        border-radius:     4px;
        margin-top:        6px;
        padding:           4px 8px;
        font-size:         13px;
      }
      .notification-action:hover {
        background-color: @accent;
        color:             @bg;
      }

      button {
        background-color: @surface-alt;
        color:             @text;
        border-radius:     4px;
        padding:           6px 12px;
      }
      button:hover {
        background-color: @muted;
      }
      button:active {
        background-color: @accent;
        color:             @bg;
      }

      scale trough {
        min-height:    4px;
        background-color: @surface-alt;
        border-radius:     4px;
      }
      scale highlight {
        background-color: @accent;
        border-radius:     4px;
      }
      scale slider {
        min-width:     12px;
        min-height:    12px;
        border-radius: 50%;
        background-color: @text;
      }
      scale slider:hover {
        background-color: @accent;
      }

      switch {
        background-color: @surface-alt;
        border-radius:     10px;
        min-width:          34px;
        min-height:         18px;
      }
      switch slider {
        background-color: @text;
        border-radius:     50%;
        min-width:          14px;
        min-height:         14px;
        margin:            2px;
      }
      switch:checked {
        background-color: @accent;
      }
      switch:checked slider {
        background-color: @bg;
      }
    '';
  };
}
