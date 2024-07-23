{
  pkgs
, ...
}:

# this works, but..... see below... maybe add #!${pkgs.runtimeShell}??
let
  mail-fetch-script = "${pkgs.writeShellScriptBin "fetch-mail12" ''
    # for x in "1 2"; do
    #     echo $x
    # done
    echo 1
    # words=("word1"
    #         "word2"
    #         "word3")
    # for word in "''${words[@]}"; do
    #     echo $word
    # done
  ''}/bin/fetch-mail";
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




#... this doesn't work??

# let
#   mail-fetch-script = "${pkgs.writeShellScriptBin "fetch-mail" ''
#     # aasdf #!${pkgs.runtimeShell}
#     # words=("word1"
#     #        "word2"
#     #        "word3")
#     echo ASDF
#     # for word in "''${words[@]}"; do
#     #     echo $word
#     # done
#   ''}/bin/fetch-mail.sh";
# in








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
