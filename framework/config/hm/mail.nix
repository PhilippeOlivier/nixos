{
  config,
  pkgs
, ...
}:

let
  mail-fetch-script = "${pkgs.writeShellScriptBin "fetch-mail" ''
    IFS=$'\n' words=( $(${pkgs.findutils}/bin/xargs -n1 <<<"$(${pkgs.coreutils}/bin/cat "${config.sops.secrets.words.path}")") )
    for word in "''${words[@]}"; do
        echo $word
    done

   #echo "$(${pkgs.coreutils}/bin/cat "${config.sops.secrets.mystring.path}")"
   ${pkgs.curl}/bin/curl -d "New mail from: WOOO" ntfy.sh/$(${pkgs.coreutils}/bin/cat "${config.sops.secrets.ntfyTopic.path}")
  ''}/bin/fetch-mail";
in

{
  sops.secrets = {
    ntfyTopic = {};
    mystring = {};
    words = {};
  };
  
  systemd.user.services."fetch-mail" = {
    Unit = {
      Description = "Fetch mail and send ntfy notifications";
    };
    Install.WantedBy = [ "default.target" ];
    Service = {
      Type = "oneshot";
      ExecStart = mail-fetch-script;
    };
  };
}
