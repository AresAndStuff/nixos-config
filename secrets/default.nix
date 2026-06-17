{ config, pkgs, agenix, mysecrets, ... }:

{
  imports = [
    agenix.nixosModules.default
  ];

  age.identityPaths = [
    "/etc/ssh/ssh_host_agenix_key"
  ];

  age.secrets = {
    "passwort-ado" = {
      file = "${mysecrets}/passwort-ado.age";
      owner = "root"; 
    };
  };
}
