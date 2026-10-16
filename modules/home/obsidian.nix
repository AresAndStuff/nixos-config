{ pkgs, lib, ... }:

let
  # Wraps a GitHub release (main.js + manifest.json [+ styles.css])
  # into a package the obsidian module can install
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
    version = "x.y.z"; # latest tag from the repo's releases page
    hashes = {
      "main.js" = lib.fakeHash;
      "manifest.json" = lib.fakeHash;
      "styles.css" = lib.fakeHash;
    };
  };
in
{
  programs.obsidian = {
    enable = true; # installs obsidian, so drop it from packages.nix

    vaults.notes = {
      target = "Documents/notes"; # relative to $HOME
      settings = {
        corePlugins = [
          "file-explorer"
          "global-search"
          "backlink"
          "outline"
          "command-palette"
          "daily-notes"
        ];
        communityPlugins = [ languagetool ];
        app = {
          vimMode = false;
          showLineNumber = true;
        };
        appearance.theme = "obsidian"; # dark
      };
    };
  };
}