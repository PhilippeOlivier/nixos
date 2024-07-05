{
  pkgs
, username
, ...
}:

{
  environment.systemPackages = with pkgs; [
    pkgs.distrobox
    pkgs.docker-compose
  ];
  
  virtualisation.docker.enable = true;

  users.users.${username}.extraGroups = [
    "docker"
  ];

  environment.persistence."/nosnap" = {
    directories = [
      "/var/lib/docker"
    ];
  };
}
