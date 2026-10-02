{ pkgs, firefox-addons, theme, ... }:

let
  addons = firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};

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
      "sidebar.revamp" = true;
      "sidebar.verticalTabs" = true;
      "sidebar.visibility" = "hide-sidebar";
      "sidebar.position_start" = true;
      "browser.compactmode.show" = true;
      "browser.uidensity" = 1;
      "browser.tabs.inTitlebar" = 1;
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
  };

  # Function to generate the userChrome block given a specific background color
  mkUserChrome = bgCol: ''
    :root {
      color-scheme: dark;
      --pfl-bg: ${bgCol};
      --pfl-fg: ${theme.text};
      --pfl-1: color-mix(in srgb, var(--pfl-fg) 8%, transparent);
      --pfl-2: color-mix(in srgb, var(--pfl-fg) 14%, transparent);
      --pfl-3: color-mix(in srgb, var(--pfl-fg) 40%, transparent);
      --pfl-r: 8px;
      --pfl-gap: 8px;
      --pfl-strip: 20px;
      --pfl-url-idle: 400px;
      --pfl-url-top: 14px;
      --pfl-url-side: 14px;
      --pfl-nav-top: 12px;

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

    :is(#sidebar-main, #sidebar-wrapper, #sidebar-container):is([hidden], [collapsed], [aria-hidden="true"]) {
      display: none !important;
    }
    :is(#sidebar-main, #sidebar-wrapper, #sidebar-container):is([hidden], [collapsed], [aria-hidden="true"]) ~ #sidebar-launcher-splitter {
      display: none !important;
    }

    #main-window:has(:is(#sidebar-main, #sidebar-wrapper, #sidebar-container):is([hidden], [collapsed], [aria-hidden="true"])) #navigator-toolbox {
      position: fixed !important;
      top: 0 !important;
      inset-inline: 0 !important;
      z-index: 10 !important;
    }

    #main-window:has(:is(#sidebar-main, #sidebar-wrapper, #sidebar-container):is([hidden], [collapsed], [aria-hidden="true"])) #navigator-toolbox:is(:hover, :focus-within) {
      padding-top: var(--pfl-nav-top) !important;
    }

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
        overflow: visible !important;
      }

      & #nav-bar-customization-target > *:not(#urlbar-container),
      & #nav-bar > *:not(#nav-bar-customization-target) {
        visibility: hidden !important;
      }

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

  mkUserContent = bgCol: ''
    @-moz-document url("about:blank"), url("about:newtab"),
                   url("about:home"), url("about:privatebrowsing") {
      :root { background-color: ${bgCol} !important; }
    }
  '';
in
{
  programs.librewolf = {
    enable = true;
    profiles = {
      default = commonSettings // {
        id = 0;
        name = "default";
        isDefault = true;
        userChrome = mkUserChrome theme.bg;
        userContent = mkUserContent theme.bg;
      };

      profile1 = commonSettings // {
        id = 1;
        name = "Profile 1";
        path = "YNN5QMIH.Profile 1";
        # Change this hex color code to whatever distinct background you want for Profile 1!
        userChrome = mkUserChrome "#444e6a"; 
        userContent = mkUserContent "#444e6a";
      };
    };
  };
}
