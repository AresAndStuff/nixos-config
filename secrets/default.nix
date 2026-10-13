{
  config,
  pkgs,
  agenix,
  mysecrets,
  ...
}:

{
  imports = [
    agenix.nixosModules.default
  ];

  age.identityPaths = [ "/var/lib/agenix/key" ];

  age.secrets = {
    "passwort-ado" = {
      file = "${mysecrets}/passwort-ado.age";
      owner = "root";
    };
  };
}
