{
  pkgs
, ...
}:

# why do i have to get cat from coreutils?

let
  mail-fetch-script = "${pkgs.writeShellScriptBin "fetch-mail" ''
    #echo $(${pkgs.coreutils}/bin/cat "/run/user/1000/secrets/words")
    # words=("word1"
    #        "word2"
    #        "word3")
    # for word in "''${words[@]}"; do
    #     echo $word
    # done
    # echo $(${pkgs.coreutils}/bin/cat "/run/user/1000/secrets/mystring")
  ''}/bin/fetch-mail";
in


{
  sops.secrets = {
    mystring = {};
    words = {}; #<-- is the array correct?
  };
  
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
