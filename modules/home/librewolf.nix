{ pkgs, firefox-addons, ... }:

let
  addons = firefox-addons.packages.${pkgs.system};
in
{
  programs.librewolf = {
    enable = true;

    # librewolf.cfg (autoconfig) – gilt profilübergreifend
    settings = {
      "widget.wayland.fractional-scale.enabled" = false;
    };

    profiles.default = {
      isDefault = true;

      # user.js prefs für dieses Profil
      settings = {
        general.autoScroll = true;
        # userChrome.css überhaupt zulassen  -> ohne das kein Rice
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # per Nix installierte Extensions automatisch aktivieren
        "extensions.autoDisableScopes" = 0;

        # LibreWolf löscht per Default Cookies + History beim Schließen -> abstellen
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy"   = 0;

        # New Tab entschlacken
        "browser.newtabpage.activity-stream.showSponsored"            = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      };

      extensions = {
        force = true;                 # überschreibt manuell installierte Erweiterungen
        packages = with addons; [
          ublock-origin
          bitwarden
          darkreader
          sponsorblock
          # weitere: vimium, ublacklist, istilldontcareaboutcookies, ...
        ];
      };

      # Der eigentliche Rice – siehe Abschnitt 4
      userChrome = ''
        #TabsToolbar { --tab-min-height: 30px !important; }

        /* Close-Button nur beim Hovern */
        .tabbrowser-tab .tab-close-button { opacity: 0; transition: opacity .15s; }
        .tabbrowser-tab:hover .tab-close-button { opacity: 1; }
      '';
    };
  };
}