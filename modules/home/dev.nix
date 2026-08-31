{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    # C toolchain
    gcc
    gnumake
    cmake
    pkg-config

    # Python
    python3
    uv
    ruff
    basedpyright

    # JS / TS
    nodejs_22
    pnpm
    typescript-language-server
    # bun

    # Rust
    rustc cargo clippy rustfmt rust-analyzer

    # Go
    go gopls

    # shell
    shellcheck
    shfmt
  ];

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
    GOPATH = "${config.home.homeDirectory}/.local/share/go";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.npm-global/bin"
    "${config.home.homeDirectory}/.local/share/go/bin"
    "${config.home.homeDirectory}/.cargo/bin"
  ];
}