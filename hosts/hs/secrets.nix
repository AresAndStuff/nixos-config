{ mysecrets, ... }:

{
  age.secrets = {
    cloudflare-token.file = "${mysecrets}/cloudflare-token.age";
    wg-hs.file = "${mysecrets}/wg-hs.age";
    proton-wg.file = "${mysecrets}/proton-wg.age";
    beszel-agent-env.file = "${mysecrets}/beszel-agent.env.age";
    homepage-env.file = "${mysecrets}/homepage.env.age";
  };
}
