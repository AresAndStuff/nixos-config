{ agenix, mysecrets, ... }:
{
  imports = [ agenix.nixosModules.default ];
  age.identityPaths = [ "/var/lib/agenix/key" ];
  age.secrets.wg-laptop-env.file = "${mysecrets}/wg-laptop.env.age";

  age.secrets = {
    "passwort-ado" = {
      file = "${mysecrets}/passwort-ado.age";
      owner = "root";
    };
  };
}
