{
  pkgs,
  firefox-addons,
  theme,
  ...
}:

let
  addons = firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};

  # Sidebery's sidebar id, used to hide the native sidebar header above it
  sideberyId = "_3c078156-979c-498b-8990-85f7987dd929_-sidebar-action";

  commonSettings = {
    settings = {
      "widget.wayland.fractional-scale.enabled" = false;
      "general.autoScroll" = true;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "extensions.autoDisableScopes" = 0;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "network.cookie.lifetimePolicy" = 0;
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "permissions.default.shortcuts" = 2;
      "browser.tabs.firefox-view" = false;
      "ui.systemUsesDarkTheme" = 1;
      "layout.css.prefers-color-scheme.content-override" = 0;
      "browser.theme.toolbar-theme" = 0;
      "browser.theme.content-theme" = 0;
      "browser.compactmode.show" = true;
      "browser.uidensity" = 1;
      "browser.tabs.inTitlebar" = 1;
      "devtools.chrome.enabled" = true;
      "devtools.debugger.remote-enabled" = true;

      # Native vertical tabs off, Sidebery takes over
      "sidebar.revamp" = false;
      "sidebar.verticalTabs" = false;

      # Containers
      "privacy.userContext.enabled" = true;
      "privacy.userContext.ui.enabled" = true;
    };

    extensions = {
      force = true;
      packages = with addons; [
        ublock-origin
        bitwarden
        darkreader
        libredirect
        auto-tab-discard
        sidebery
      ];
    };
  };

  mkUserChrome = bg: ''
    :root {
      color-scheme: dark;
      --pfl-bg: ${bg};
      --pfl-fg: ${theme.text};
      --pfl-1: color-mix(in srgb, var(--pfl-fg) 8%, transparent);
      --pfl-2: color-mix(in srgb, var(--pfl-fg) 14%, transparent);
      --pfl-3: color-mix(in srgb, var(--pfl-fg) 40%, transparent);
      --pfl-r: 8px;

      --toolbar-bgcolor: var(--pfl-bg) !important;
      --toolbar-color: var(--pfl-fg) !important;
      --lwt-accent-color: var(--pfl-bg) !important;
      --lwt-text-color: var(--pfl-fg) !important;
      --toolbarbutton-icon-fill: var(--pfl-fg) !important;
      --toolbarbutton-hover-background: var(--pfl-1) !important;
      --toolbarbutton-active-background: var(--pfl-2) !important;
      --toolbar-field-background-color: var(--pfl-bg) !important;
      --toolbar-field-focus-background-color: var(--pfl-bg) !important;
      --toolbar-field-color: var(--pfl-fg) !important;
      --toolbar-field-focus-color: var(--pfl-fg) !important;
      --sidebar-background-color: var(--pfl-bg) !important;
      --sidebar-text-color: var(--pfl-fg) !important;
      --arrowpanel-background: var(--pfl-bg) !important;
      --arrowpanel-color: var(--pfl-fg) !important;
      --arrowpanel-border-color: var(--pfl-1) !important;
      --chrome-content-separator-color: transparent !important;
    }

    /* Sidebery replaces the tab strip */
    #TabsToolbar { visibility: collapse !important; }
    #sidebar-box[sidebarcommand="${sideberyId}"] #sidebar-header { display: none !important; }

    #toolbar-menubar, #firefox-view-button,
    .titlebar-buttonbox-container, .titlebar-spacer {
      display: none !important;
    }

    /* Chrome */
    #navigator-toolbox, #browser, #sidebar-box {
      background: var(--pfl-bg) !important;
      border: none !important;
    }
    #nav-bar { border: none !important; box-shadow: none !important; }
    #nav-bar .toolbarbutton-text { display: none !important; }
    #sidebar-splitter {
      width: 1px !important;
      min-width: 1px !important;
      background: transparent !important;
      border: none !important;
    }

    /* Rounded, inset page */
    #tabbrowser-tabbox {
      margin: 0 8px 8px 0 !important;
      border-radius: var(--pfl-r) !important;
      overflow: hidden !important;
      outline: 1px solid var(--pfl-1) !important;
      outline-offset: -1px !important;
    }
    .browserStack, .browserContainer, #tabbrowser-tabpanels {
      border-radius: inherit !important;
    }

    /* URL bar */
    #urlbar-background, #urlbar[open] > .urlbarView {
      background: var(--pfl-bg) !important;
      border: 1px solid var(--pfl-1) !important;
      border-radius: var(--pfl-r) !important;
    }
    #urlbar[focused] > #urlbar-background { border-color: var(--pfl-3) !important; }
    #urlbar:not([focused]) #page-action-buttons { display: none !important; }

    /* Popups */
    menupopup, panel {
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

  mkUserContent = bg: ''
    @-moz-document url("about:blank"), url("about:newtab"),
                   url("about:home"), url("about:privatebrowsing") {
      :root { background-color: ${bg} !important; }
    }
  '';

in
{
  programs.librewolf = {
    enable = true;
    profiles.default = commonSettings // {
      id = 0;
      name = "default";
      isDefault = true;
      userChrome = mkUserChrome theme.bg;
      userContent = mkUserContent theme.bg;

      # Replace containers made in the UI with exactly these
      containersForce = true;
      containers = {
        Personal = { id = 1; color = "blue"; icon = "fingerprint"; };
        Work = { id = 2; color = "orange"; icon = "briefcase"; };
      };
    };
  };
}
