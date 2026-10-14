{ mysecrets, ... }:

{
  age.secrets = {
    cloudflare-token.file = "${mysecrets}/cloudflare-token.age";
    wg-hs.file = "${mysecrets}/wg-hs.age";
  };
}
