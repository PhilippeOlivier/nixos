# NixOS Configuration


## Layout


### `/installation`

Instructions on how to install the system.

Here is a list of machine-specific values that should be reviewed upon installation:
- Identifier of the touchpad and the keyboard. These can be shown with `swaymsg -t get_inputs`, and can be found in `/modules/home/sway.nix`.
- The position of `gsimplecal`, found in `/modules/home/sway.nix`.
- The battery identifier, which is the name of the directory `/sys/class/power_supply/BAT*`. This name should be given to the variable `BATTERY` in the `"custom/battery"` Waybar module in `/modules/home/sway.nix`.
- The path `/sys/class/leds/input*::capslock/brightness` may be different on some machines. It is required for the `"custom/keyboard"` and `"custom/keyboard-capslock-daemon"` Waybar modules in `/modules/home/sway.nix`.
- The values of `WIFI_INTERFACE` and `ETH_INTERFACE` in `/modules/home/sway.nix` can be found with `ip link show`.


### `/modules`

Most of the configuration can be found in the various files here.


#### `boot.nix`

Note: If the default boot option is not the latest generation, press `d` to clear the default.


#### `home.nix` and `/home/*.nix`

Everything related to Home Manager.


##### Sway & Waybar

The signals used for Sway and Waybar are the following:
- Brightness: 11
- Battery: 12
- Volume: 13
- Keyboard: 14
- Network: 15
- Mail: 16


### `/secrets`

This includes all secret information such as SSH keys, WiFi networks and passwords, etc.
