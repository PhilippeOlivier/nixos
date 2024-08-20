{
  pkgs
, ...
}:

{
  home = {
    packages = with pkgs; [
      minetest
    ];

    persistence = {
      "/snap/home/${username}" = {
        directories = [
          ".minetest"
        ];
      };
    };
  };
}
