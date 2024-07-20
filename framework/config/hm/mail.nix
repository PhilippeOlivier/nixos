{
  pkgs
, ...
}:

let
  mail-fetch-script = "${pkgs.writeShellScriptBin "fetch-mail4" ''
    #!${pkgs.runtimeShell}
    words=("word1"
           "word2"
           "word3")
    echo ASDF
    # for word in "''${words[@]}"; do
    #     echo $word
    # done
  ''}/bin/fetch-mail.sh";
in


{
  systemd.user.services."fetch-mail" = {
    Unit = {
      Description = "Fetch mail for all mailboxes";
    };
    Install.WantedBy = [ "default.target" ];
    Service = {
      Type = "oneshot";
      ExecStart = mail-fetch-script;
    };
  };
}














# {
#   systemd.user.services."fetch-mail" = {
#     Unit = {
#       Description = "ASFDASDFA";
#     };

#     Install.WantedBy = [ "default.target" ];

#     Service = {
#       Type = "oneshot";
#       ExecStart = "${pkgs.writeShellScriptBin "fetch-mail" ''
#           echo asdf
#         ''}/bin/fetch-mail";
#     };
#   };

# }
