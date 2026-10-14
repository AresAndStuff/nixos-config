{ mysecrets, ... }:

{
  age.secrets.wg-laptop-env.file = "${mysecrets}/wg-laptop.env.age";
}
