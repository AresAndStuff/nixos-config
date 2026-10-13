{ agenix, mysecrets, ... }:

{
  imports = [ agenix.nixosModules.default ];

  age.identityPaths = [ "/var/lib/agenix/key" ];

  age.secrets = {
    cloudflare-token.file = "${mysecrets}/cloudflare-token.age";
    wg-hs.file = "${mysecrets}/wg-hs.age";
  };
}
