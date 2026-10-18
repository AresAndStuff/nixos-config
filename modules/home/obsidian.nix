{
  lib,
  pkgs,
  osConfig,
  ...
}:

let
  mkPlugin =
    {
      owner,
      repo,
      version,
      hashes,
      id ? repo, # manifest.json "id", checked when the plugin is built
    }:
    pkgs.runCommandLocal "obsidian-plugin-${id}-${version}"
      {
        # Home Manager names the plugin folder after the manifest id. Without
        # this it reads manifest.json during evaluation, so every rebuild had
        # to build the plugin before evaluation could finish.
        passthru.manifestId = id;
      }
      ''
        mkdir -p $out
        ${lib.concatMapAttrsStringSep "\n" (
          file: hash:
          "cp ${
            pkgs.fetchurl {
              url = "https://github.com/${owner}/${repo}/releases/download/${version}/${file}";
              inherit hash;
            }
          } $out/${file}"
        ) hashes}

        actual=$(${lib.getExe pkgs.jq} -r .id $out/manifest.json)
        if [ "$actual" != ${lib.escapeShellArg id} ]; then
          echo "${repo}: manifest id is '$actual', pass id = \"$actual\"" >&2
          exit 1
        fi
      '';

  languagetool = mkPlugin {
    owner = "Clemens-E";
    repo = "obsidian-languagetool-plugin";
    version = "0.4.3";
    hashes = {
      "main.js" = "sha256-8tMTTYw4wE7FAb2mZtXiyUDKVfSBRPd0lkfJUFpq3cQ=";
      "manifest.json" = "sha256-FN4FqK9Pvh1wRyEGbZUF/KpnteJpvwEyW7egWCNPzR0=";
      "styles.css" = "sha256-p3ErAxKD0xzS8mZTogagHBZpdrcIH0OhHZyVTNuwlhw=";
    };
  };

  encryptedGitSync = mkPlugin {
    owner = "AresAndStuff";
    repo = "encrypted-git-sync";
    version = "0.3.0";
    hashes = {
      "main.js" = "sha256-p7rQzZLbgqf9p2Tey2wUpbXkzYabMeiBhXTj1Xd5Ako=";
      "manifest.json" = "sha256-ntbeLQu0usZ2okP5ctTA8kNdor5lNBy2XN/+weLYcLo=";
      "styles.css" = "sha256-lK4x1DVZ+P2kfVWi5wPHqlVbcYvyXSibMzZ0uG8anY0=";
    };
  };

  # The LanguageTool server from modules/nixos/workstation/languagetool.nix,
  languagetoolUrl = "http://${lib.head osConfig.systemd.sockets.languagetool-proxy.listenStreams}";

  # SDDM unlocks KWallet at login on the desktop, but Electron
  # doesn't recognise Hyprland, so the store has to be named there.
  # Electron finds GNOME Keyring by itself.
  usesKwallet = osConfig.security.pam.services.sddm.kwallet.enable or false;
in
{
  programs.obsidian = {
    enable = true;
    package = lib.mkIf usesKwallet (
      pkgs.obsidian.override { commandLineArgs = "--password-store=kwallet6"; }
    );

    vaults.notes = {
      target = "Documents/vault";
      settings = {
        corePlugins = [
          "file-explorer"
          "global-search"
          "backlink"
          "outline"
          "command-palette"
          "daily-notes"
        ];
        communityPlugins = [
          {
            pkg = languagetool;
            # changes made in the plugin's settings tab won't stick; set them here.
            settings = {
              serverUrl = languagetoolUrl;
              urlMode = "custom";
              apiKeyStorage = "secret";
            };
          }
          # the plugin writes a generated vaultId to its data.json
          # on first start, so that file has to stay writable.
          encryptedGitSync
        ];
        app = {
          vimMode = false;
          showLineNumber = true;
        };
        appearance.theme = "obsidian";
      };
    };
  };
}
