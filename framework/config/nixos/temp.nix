{config,pkgs, username, ...}:

{
  # This below can be deleted I think
  sops.secrets."ntfy_topic" = {
    owner = config.users.users.${username}.name;
    group = config.users.users.${username}.group;
  };


  # systemd.services."test" = {
  #   requires = [
  #     "network-online.target"
  #   ];
  #   after = [
  #     "network-online.target"
  #   ];
  #   script = ''
  #     touch /home/pholi/$(cat ${config.sops.secrets."ntfy_topic".path})
  #   '';
  #   serviceConfig = {
  #     Type = "oneshot";
  #     #ExecStartPre = "sleep 10";
  #     User = username;
  #     Group = "users";
  #   };
  # };

  # systemd.services."fetch-mail" = {
  #   enable = true;
  #   wantedBy = [ "multi-user.target" ];
  #   requires = [ "network-online.target" ];
  #   after = [ "network-online.target" ];
  #   script = ''
  #     echo asdf
  #   '';
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = "pholi";
  #     Group = "users";
  #   };
  # };
}
