{ pkgs, firefox-addons, theme, ... }:

let
  addons = firefox-addons.packages.${pkgs.system};
in
{
  programs.librewolf = {
    enable = true;

    settings = {
      "widget.wayland.fractional-scale.enabled" = false;
    };

    profiles.default = {
      isDefault = true;

      settings = {
        # NOTE: gequotet! Unquoted parst Nix das als verschachteltes Attrset.
        "general.autoScroll" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "extensions.autoDisableScopes" = 0;

        # LibreWolf räumt beim Schließen auf -> abstellen
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;

        # New Tab entschlacken
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;

        # Seiten dürfen Ctrl+L / Ctrl+Alt+Z nicht abfangen
        "permissions.default.shortcuts" = 2;
        "browser.tabs.firefox-view" = false;

        # immer dunkel, kein System-Light
        "ui.systemUsesDarkTheme" = 1;
        "layout.css.prefers-color-scheme.content-override" = 0; # 0=dark
        "browser.theme.toolbar-theme" = 0;
        "browser.theme.content-theme" = 0;

        # vertikale Tabs. "hide-sidebar" == Häkchen "Tabs und Sidebar
        # ausblenden" -> erst dadurch blendet Ctrl+Alt+Z komplett aus
        # statt nur auf die Icon-Leiste einzuklappen.
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "sidebar.visibility" = "hide-sidebar";
        "sidebar.position_start" = true;

        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;
        "browser.tabs.inTitlebar" = 1; # CSD behalten, Buttons killt das CSS

        # Browser Toolbox (Ctrl+Alt+Shift+I)
        "devtools.chrome.enabled" = true;
        "devtools.debugger.remote-enabled" = true;
      };

      extensions = {
        force = true;
        packages = with addons; [
          ublock-origin
          bitwarden
          darkreader
          libredirect
          auto-tab-discard
        ];
      };

      # ================================================================
      #  Zwei Farben, kein Loader, kein JS.
      #  Ctrl+Alt+Z -> Sidebar UND Toolbar weg (bzw. wieder da)
      #  danach: Maus an den oberen Rand oder Ctrl+L holt die Toolbar
      #  kurz zurück, ohne die Sidebar mitzubringen
      #  ohne Sidebar schwebt nur noch eine Urlbar-Pille über dem
      #  Inhalt, bei Hover/Ctrl+L kommt die volle Toolbar zurück
      # ================================================================
      userChrome = ''
        :root {
          color-scheme: dark;
          --pfl-bg: ${theme.bg};
          --pfl-fg: ${theme.text};
          --pfl-1: color-mix(in srgb, var(--pfl-fg) 8%, transparent);
          --pfl-2: color-mix(in srgb, var(--pfl-fg) 14%, transparent);
          --pfl-3: color-mix(in srgb, var(--pfl-fg) 40%, transparent);
          --pfl-r: 8px;
          --pfl-gap: 8px;
          --pfl-strip: 20px;      /* Hover-Ziel am oberen Rand */
          --pfl-url-idle: 400px;   /* Breite der schwebenden Urlbar-Pille */
          --pfl-url-top: 14px;    /* Abstand der Pille von oben */
          --pfl-url-side: 14px;   /* Abstand der Pille vom linken Rand */
          --pfl-nav-top: 12px;    /* Luft über der ausgeklappten Toolbar */

          --toolbar-bgcolor: var(--pfl-bg) !important;
          --toolbar-color: var(--pfl-fg) !important;
          --lwt-accent-color: var(--pfl-bg) !important;
          --lwt-text-color: var(--pfl-fg) !important;
          --toolbarbutton-icon-fill: var(--pfl-fg) !important;
          --toolbarbutton-icon-fill-attention: var(--pfl-fg) !important;
          --toolbarbutton-hover-background: var(--pfl-1) !important;
          --toolbarbutton-active-background: var(--pfl-2) !important;
          --toolbar-field-background-color: var(--pfl-bg) !important;
          --toolbar-field-focus-background-color: var(--pfl-bg) !important;
          --toolbar-field-color: var(--pfl-fg) !important;
          --toolbar-field-focus-color: var(--pfl-fg) !important;
          --urlbar-box-bgcolor: var(--pfl-bg) !important;
          --urlbarview-background-color-hover: var(--pfl-1) !important;
          --urlbarview-background-color-selected: var(--pfl-2) !important;
          --sidebar-background-color: var(--pfl-bg) !important;
          --sidebar-text-color: var(--pfl-fg) !important;
          --tabpanel-background-color: var(--pfl-bg) !important;
          --tab-selected-bgcolor: var(--pfl-2) !important;
          --tab-selected-textcolor: var(--pfl-fg) !important;
          --tab-loading-fill: var(--pfl-fg) !important;
          --lwt-tab-line-color: transparent !important;
          --chrome-content-separator-color: transparent !important;
          --arrowpanel-background: var(--pfl-bg) !important;
          --arrowpanel-color: var(--pfl-fg) !important;
          --arrowpanel-border-color: var(--pfl-1) !important;
        }

        /* Menüleiste, Firefox View, Fensterknöpfe (macht Hyprland) */
        #toolbar-menubar, #vertical-spacer, #firefox-view-button,
        #alltabs-button, #new-tab-button, #tabs-newtab-button,
        #vertical-tabs-newtab-button, #vertical-tabs-newtab-container,
        .titlebar-buttonbox-container, .titlebar-spacer {
          display: none !important;
        }

        #navigator-toolbox {
          background: var(--pfl-bg) !important;
          border: none !important;
        }
        #nav-bar {
          border: none !important;
          box-shadow: none !important;
          padding-inline: var(--pfl-gap) !important;
        }
        #nav-bar .toolbarbutton-text { display: none !important; }

        /* Ctrl+Alt+Z: Sidebar weg, nichts soll stehen bleiben. */
        :is(#sidebar-main, #sidebar-wrapper, #sidebar-container):is([hidden], [collapsed], [aria-hidden="true"]) {
          display: none !important;
        }
        :is(#sidebar-main, #sidebar-wrapper, #sidebar-container):is([hidden], [collapsed], [aria-hidden="true"]) ~ #sidebar-launcher-splitter {
          display: none !important;
        }

        /* Toolbar schwebend NUR WENN Sidebar ausgeblendet ist */
        #main-window:has(:is(#sidebar-main, #sidebar-wrapper, #sidebar-container):is([hidden], [collapsed], [aria-hidden="true"])) #navigator-toolbox {
          position: fixed !important;
          top: 0 !important;
          inset-inline: 0 !important;
          z-index: 10 !important;
        }

        /* ausgeklappt: etwas Luft nach oben */
        #main-window:has(:is(#sidebar-main, #sidebar-wrapper, #sidebar-container):is([hidden], [collapsed], [aria-hidden="true"])) #navigator-toolbox:is(:hover, :focus-within) {
          padding-top: var(--pfl-nav-top) !important;
        }

        /* Eingeklappt = Sidebar weg UND kein Hover UND kein Fokus. */
        #main-window:has(:is(#sidebar-main, #sidebar-wrapper, #sidebar-container):is([hidden], [collapsed], [aria-hidden="true"]))
        #navigator-toolbox:not(:hover):not(:focus-within) {
          height: var(--pfl-strip) !important;
          min-height: 0 !important;
          background: transparent !important;

          & #nav-bar {
            height: 0 !important;
            min-height: 0 !important;
            padding: 0 !important;
            margin: 0 !important;
            overflow: visible !important; /* Pille darf rausragen */
          }

          /* alles außer der Urlbar verschwindet */
          & #nav-bar-customization-target > *:not(#urlbar-container),
          & #nav-bar > *:not(#nav-bar-customization-target) {
            visibility: hidden !important;
          }

          /* Urlbar schwebt als Pille über dem Inhalt */
          & #urlbar-container {
            position: fixed !important;
            top: var(--pfl-url-top) !important;
            inset-inline-start: var(--pfl-url-side) !important;
            width: var(--pfl-url-idle) !important;
            min-width: 0 !important;
            margin: 0 !important;
            z-index: 4 !important;
          }
          & #urlbar { --urlbar-width: var(--pfl-url-idle) !important; }
          & #urlbar-background { box-shadow: 0 4px 16px rgba(0,0,0,.5) !important; }
          & #urlbar-input-container { overflow: hidden !important; }
          & #urlbar-go-button { display: none !important; }
        }

        #sidebar-main {
          background: var(--pfl-bg) !important;
          border: none !important;
          scrollbar-width: thin !important;
        }
        #sidebar-main .tabbrowser-tab { --tab-min-height: 30px !important; }
        #sidebar-main .tab-background {
          border: none !important;
          border-radius: 6px !important;
          margin-inline: 4px !important;
          box-shadow: none !important;
        }
        #sidebar-main .tabbrowser-tab:hover .tab-background {
          background: var(--pfl-1) !important;
        }
        #sidebar-main .tabbrowser-tab[selected] .tab-background {
          background: var(--pfl-2) !important;
        }
        #sidebar-main .tabbrowser-tab[pending] .tab-label { opacity: .55 !important; }
        #sidebar-main .tab-close-button { opacity: 0 !important; }
        #sidebar-main .tabbrowser-tab:hover .tab-close-button { opacity: 1 !important; }

        #tabbrowser-tabbox {
          margin: var(--pfl-gap) !important;
          border-radius: var(--pfl-r) !important;
          overflow: hidden !important;
          outline: 1px solid var(--pfl-1) !important;
          outline-offset: -1px !important;
        }
        .browserStack, .browserContainer, #tabbrowser-tabpanels {
          border-radius: inherit !important;
        }

        /* ---- Urlbar ------------------------------------------------ */
        #urlbar { --urlbar-height: 32px !important; }
        #urlbar-background, #urlbar[open] > .urlbarView {
          background: var(--pfl-bg) !important;
          border: 1px solid var(--pfl-1) !important;
          border-radius: var(--pfl-r) !important;
        }
        #urlbar[focused] > #urlbar-background { border-color: var(--pfl-3) !important; }
        #urlbar:not([focused]) #page-action-buttons { display: none !important; }
        #urlbar[breakout][breakout-extend] {
          width: 75% !important;
          left: 0 !important;
          right: 0 !important;
          margin-inline: auto !important;
        }

        menupopup, panel, .panel-arrowcontent {
          --panel-background: var(--pfl-bg) !important;
          --panel-color: var(--pfl-fg) !important;
          --panel-border-color: var(--pfl-1) !important;
          --panel-border-radius: var(--pfl-r) !important;
        }
        findbar {
          background: var(--pfl-bg) !important;
          border-top: 1px solid var(--pfl-1) !important;
        }
      '';

      userContent = ''
        @-moz-document url("about:blank"), url("about:newtab"),
                       url("about:home"), url("about:privatebrowsing") {
          :root { background-color: ${theme.bg} !important; }
        }
      '';
    };
  };
}
