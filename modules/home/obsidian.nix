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
    version = "0.1.0";
    hashes = {
      "main.js" = "sha256-RorcIeqBBJLh/BWlshsqh1vd+PPmDAm2GAmp/MX2d30=";
      "manifest.json" = "sha256-k+t+plqadd91BzHE6PEpc3mDQsO/f18ZJXsDQ3cffm8=";
      "styles.css" = "sha256-lK4x1DVZ+P2kfVWi5wPHqlVbcYvyXSibMzZ0uG8anY0=";
    };
  };
in
{
  programs.obsidian = {
    enable = true;

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
        communityPlugins = [ languagetool encryptedGitSync ];
        app = {
          vimMode = false;
          showLineNumber = true;
        };
        appearance.theme = "obsidian";
      };
    };
  };
}