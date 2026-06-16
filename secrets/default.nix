{ config, pkgs, agenix, mysecrets, ... }:

{
  imports = [
    # Aktiviert das agenix-Modul für dieses System
    agenix.nixosModules.default
  ];

  # Welcher lokale Schlüssel wird zum Entschlüsseln auf diesem PC genutzt?
  age.identityPaths = [
    "/etc/ssh/ssh_host_agenix_key"
  ];

  # Hier wird das Geheimnis definiert
  age.secrets."mein-passwort" = {
    # Nimmt die verschlüsselte Datei aus dem privaten Repo-Input
    file = "${mysecrets}/xxx.age";  
    
    # Hier liegt das Passwort nach dem Booten/Switch unverschlüsselt (nur für root lesbar)
    path = "/etc/xxx/geheimnis.txt"; 
    
    mode = "0400";
    owner = "root";
    group = "root";
  };
}