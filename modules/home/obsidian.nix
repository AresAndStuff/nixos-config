{ pkgs, lib, ... }:

let
  mkPlugin =
    {
      owner,
      repo,
      version,
      hashes,
      styles ? true,
    }:
    let
      fetch =
        file:
        pkgs.fetchurl {
          url = "https://github.com/${owner}/${repo}/releases/download/${version}/${file}";
          hash = hashes.${file};
        };
    in
    pkgs.runCommand "obsidian-plugin-${repo}-${version}" { } ''
      mkdir -p $out
      cp ${fetch "main.js"} $out/main.js
      cp ${fetch "manifest.json"} $out/manifest.json
      ${lib.optionalString styles "cp ${fetch "styles.css"} $out/styles.css"}
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
      "main.js" =  "sha256-p7rQzZLbgqf9p2Tey2wUpbXkzYabMeiBhXTj1Xd5Ako=";
      "manifest.json" =  "sha256-ntbeLQu0usZ2okP5ctTA8kNdor5lNBy2XN/+weLYcLo=";
      "styles.css" = "sha256-lK4x1DVZ+P2kfVWi5wPHqlVbcYvyXSibMzZ0uG8anY0=";
    };
  };
in
{
  programs.obsidian = {
    enable = true; #
    package = pkgs.obsidian.override {
      commandLineArgs = "--password-store=kwallet6";
    };

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
          languagetool
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