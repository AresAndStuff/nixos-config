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

  latexSuite = mkPlugin {
    owner = "artisticat1";
    repo = "obsidian-latex-suite";
    version = "1.14.1";
    hashes = {
      "main.js" = "sha256-JJ2LDqyXbjufqFGLaPRI153wengANjYvUU5mzqn+PUs=";
      "manifest.json" = "sha256-MgGo1dKgGFnaza+YXW1WVFiAo4+ZnCFH5d8u2wpGk2U=";
      "styles.css" = "sha256-ouLvTepHnpwjd/CpiD/lOfwrEpskSGNCQwn4+SwdyBQ=";
    };
  };

  dayPlanner = mkPlugin {
    owner = "ivan-lednev";
    repo = "obsidian-day-planner";
    version = "0.35.1";
    hashes = {
      "main.js" = "sha256-ZACQBfCYW9x5qLWG+6FMWdTacA8Bm1T+2d9yXoQNryw=";
      "manifest.json" = "sha256-E45igMFiXYWfXLLhsORpluSveVDXxjcML8cAm51YYxI=";
      "styles.css" = "sha256-evDbto8o6Ui/PlUOfnCC5jL9STj22DH93aV671KGsRo=";
    };
  };

  encryptedGitSync = mkPlugin {
    owner = "AresAndStuff";
    repo = "encrypted-git-sync";
    version = "0.4.0";
    hashes = {
      "main.js" = "sha256-yEPBFRNb/DMIL0ci7+03pOqdiJ8zL8N+tKtROo51hMc=";
      "manifest.json" = "sha256-6Mm5lTOhLAb2TAvAkdhgUu2AV2c9eTVFsGG8BkSIENE=";
      "styles.css" = "sha256-ZhSZDoJYyGKEX9/9TIm7OIAFK9BdPIkurgX8SEcbmHw=";
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
          latexSuite
          dayPlanner
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
