{
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  home.packages = with pkgs; [
    loupe
    wl-clipboard
    slurp
    grim
    libnotify
    file-roller
    gnome-text-editor
  ];

  services.hyprpolkitagent.enable = true;
  programs.zathura.enable = true;
  programs.btop = {
    enable = true;
    package = pkgs.btop.override {
      cudaSupport = lib.elem "nvidia" osConfig.services.xserver.videoDrivers;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "thunar.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "text/plain" = "org.gnome.TextEditor.desktop";
    };
  };
}
