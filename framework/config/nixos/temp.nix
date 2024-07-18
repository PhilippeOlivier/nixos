{config,pkgs, username, ...}:

{
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
  
  # systemd.user.services."test" = {
  systemd.services."test" = {
    enable = true;
    # requires = [
    #   "network-online.target"
    # ];
    # after = [
    #   "network-online.target"
    # ];
    script = ''
      echo asdf
      #touch /snap/home/pholi/asdf
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "pholi";
      Group = "users";
    };
  };
}
