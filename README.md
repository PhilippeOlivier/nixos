# NixOS Configuration


## Layout


### `installation/`

Instructions on how to install the system.

Here is a list of machine-specific values that should be reviewed upon installation:
- Identifier of the touchpad and the keyboard. These can be shown with `swaymsg -t get_inputs`, and can be found in `/modules/home/sway.nix`.
- The position of `gsimplecal`, found in `/modules/home/sway.nix`.
- The battery identifier, which is the name of the directory `/sys/class/power_supply/BAT*`. This name should be given to the variable `BATTERY` in the `"custom/battery"` Waybar module in `/modules/home/sway.nix`.
- The path `/sys/class/leds/input*::capslock/brightness` may be different on some machines. It is required for the `"custom/keyboard"` and `"custom/keyboard-capslock-daemon"` Waybar modules in `/modules/home/sway.nix`.
- The values of `WIFI_INTERFACE` and `ETH_INTERFACE` in `/modules/home/sway.nix` can be found with `ip link show`.


### `modules/`

Most of the configuration can be found in the various files here.


#### `boot.nix`

Note: If the default boot option is not the latest generation, press `d` to clear the default.


#### `home.nix` and `home/*.nix`

Everything related to Home Manager.


##### Sway & Waybar

The signals used for Sway and Waybar are the following:
- Brightness: 11
- Battery: 12
- Volume: 13
- Keyboard: 14
- Network: 15
- Mail: 16


## Programs


### htop

| Command      | Description                      |
|--------------|----------------------------------|
| htop -F NAME | Starts htop and filters for NAME |
| Z            | Freezes the output inside htop   |


### inkscape

Creating SVG images for Beamer presentations:

1. Make sure that the document size is 450x280 pixels (this might be an artefact of the technique I first used when I started using Inkscape).
2. Create the SVG images and save them as SVG.
3. To use them in LaTeX, save the SVG images as PDF.
4. The PDFs should now all have the same width/height.


### pdf


#### qpdf

Extract pages 1 to 10:

```bash
    $ qpdf --empty --pages infile.pdf 1-10 -- outfile.pdf
```

Append `file1.pdf` and `file2.pdf`:

```bash
    $ qpdf --empty --pages file1.pdf file2.pdf -- outfile.pdf
```


#### xournalpp

Inserting a signature:

1. Open the PDF with Xournal++
2. Tools > Image
3. Click on the location to insert signature.png, then scale the signature
4. File > Export as PDF (choose a new file name)
5. Quit without saving

The signature will not be an image that can be further manipulated, it will instead be embedded directly into the PDF.


#### zathura

| Command                  | Description                         |
|--------------------------|-------------------------------------|
| pgdn (or J), pgup (or K) | Go to the next/previous page        |
| gg, G                    | Go to the first/last page           |
| nG                       | Go to the nth page                  |
| +, -                     | Zoom in/out                         |
| r                        | Rotate 90 degrees                   |
| a                        | Fit page to screen                  |
| s                        | Fit page width to screen            |
| F11                      | Enter/exit full screen              |
| / [string] RET           | Search (n for next, N for previous) |
| q                        | Quit                                |
