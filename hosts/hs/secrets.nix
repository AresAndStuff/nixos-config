{ agenix, mysecrets, ... }:

{
  imports = [ agenix.nixosModules.default ];

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  age.secrets.cloudflare-token.file = "${mysecrets}/cloudflare-token.age";
}
