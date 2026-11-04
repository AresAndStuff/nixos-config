{
  config,
  pkgs,
  lan,
  mysecrets,
  ...
}:

# What the graphical machines (desktop, laptop) have in common.
# The desktop environment itself (GNOME/Hyprland) comes from desktops/.
{
  imports = [
    ./bluetooth.nix
    ./languagetool.nix
    ./flatpak.nix
  ];

  networking.networkmanager.enable = true;

  # Sunrise's resolver drops public records that point at private addresses,
  # so the Vaultwarden name is pinned here instead of relying on DNS.
  # Away from home it is reached through the VPN (laptop allowed-ips).
  networking.hosts.${lan.hs.ip} = [ "vault.${lan.domain}" ];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    corefonts
    vista-fonts
    liberation_ttf
    dejavu_fonts
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = [ "Hack Nerd Font Mono" ];
  };

  services.printing.enable = true;
  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  # Same password on desktop and laptop, from agenix
  age.secrets.passwort-ado.file = "${mysecrets}/passwort-ado.age";
  users.mutableUsers = false;

  users.users.ado = {
    hashedPasswordFile = config.age.secrets.passwort-ado.path;
    isNormalUser = true;
    description = "ado";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
    ];
    shell = pkgs.zsh;
  };
}
