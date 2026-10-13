{ ... }:

{
  # Einzige Stelle fuer die Heimnetz-Adressen.
  # Das v6-Praefix vergibt Sunrise dynamisch. Bei einem Wechsel nur hier
  # aendern. Aktuelles Praefix: ip -6 addr show scope global
  _module.args.lan = {
    v4 = "192.168.1.0/24";
    v6 = "2001:1708:2498:500::/64";
    linkLocal = "fe80::/10";
  };
}