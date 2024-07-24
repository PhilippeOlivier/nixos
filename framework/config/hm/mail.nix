{
  config
, pkgs
, ...
}:

let
  mail-fetch-script = "${pkgs.writeShellScriptBin "fetch-mail" ''
    IFS=$'\n' special_emails=($(${pkgs.findutils}/bin/xargs -n1 <<<"$(${pkgs.coreutils}/bin/cat "${config.sops.secrets.specialEmails.path}")"))
    IFS=$'\n' special_terms=($(${pkgs.findutils}/bin/xargs -n1 <<<"$(${pkgs.coreutils}/bin/cat "${config.sops.secrets.specialTerms.path}")"))

    echo EMAILS
    for email in "''${special_emails[@]}"; do
        echo $email
    done

    echo TERMS
    for term in "''${special_terms[@]}"; do
        echo $term
    done

   ${pkgs.curl}/bin/curl -d "New mail from: WOOO" ntfy.sh/"$(${pkgs.coreutils}/bin/cat "${config.sops.secrets.ntfyTopic.path}")"
  ''}/bin/fetch-mail";
in

{
  sops.secrets = {
    specialEmails = {};
    specialTerms = {};
    ntfyTopic = {};
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
