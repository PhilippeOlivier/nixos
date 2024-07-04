{
  pkgs
, desktopEntriesDirectory
, ...
}:

let
  desktopEntry = import ./desktop-entry.nix { desktopEntriesDirectory = desktopEntriesDirectory; };
in

{
  xdg.dataFile = desktopEntry {
    name = "Transmission";
    exec = "transmission-gtk";
  };
  
  home = {
    packages = with pkgs; [
      transmission-gtk
    ];
    
    file.".config/transmission/settings.json".text = ''
      {
          "alt-speed-down": 50,
          "alt-speed-enabled": false,
          "alt-speed-time-begin": 540,
          "alt-speed-time-day": 127,
          "alt-speed-time-enabled": false,
          "alt-speed-time-end": 1020,
          "alt-speed-up": 0,
          "bind-address-ipv4": "0.0.0.0",
          "bind-address-ipv6": "::",
          "blocklist-date": 0,
          "blocklist-enabled": false,
          "blocklist-updates-enabled": true,
          "blocklist-url": "http://www.example.com/blocklist",
          "cache-size-mb": 4,
          "compact-view": true,
          "default-trackers": "",
          "details-window-height": 572,
          "details-window-width": 700,
          "dht-enabled": true,
          "download-dir": "/home/pholi/torrents",
          "download-queue-enabled": true,
          "download-queue-size": 20,
          "encryption": 1,
          "filter-mode": "show-all",
          "filter-trackers": "",
          "idle-seeding-limit": 30,
          "idle-seeding-limit-enabled": false,
          "incomplete-dir": "/home/pholi/torrents",
          "incomplete-dir-enabled": false,
          "inhibit-desktop-hibernation": false,
          "lpd-enabled": false,
          "main-window-height": 1469,
          "main-window-is-maximized": 0,
          "main-window-layout-order": "menu,toolbar,filter,list,statusbar",
          "main-window-width": 1124,
          "main-window-x": 1130,
          "main-window-y": 2,
          "message-level": 2,
          "open-dialog-dir": "/home/pholi",
          "peer-congestion-algorithm": "",
          "peer-id-ttl-hours": 6,
          "peer-limit-global": 200,
          "peer-limit-per-torrent": 50,
          "peer-port": 51413,
          "peer-port-random-high": 65535,
          "peer-port-random-low": 49152,
          "peer-port-random-on-start": false,
          "peer-socket-tos": "",
          "pex-enabled": true,
          "port-forwarding-enabled": true,
          "preallocation": 1,
          "prefetch-enabled": true,
          "prompt-before-exit": true,
          "queue-stalled-enabled": true,
          "queue-stalled-minutes": 30,
          "ratio-limit": 2,
          "ratio-limit-enabled": false,
          "read-clipboard": false,
          "remote-session-enabled": false,
          "remote-session-host": "localhost",
          "remote-session-https": false,
          "remote-session-password": "",
          "remote-session-port": 9091,
          "remote-session-requres-authentication": false,
          "remote-session-username": "",
          "rename-partial-files": true,
          "rpc-authentication-required": false,
          "rpc-bind-address": "0.0.0.0",
          "rpc-enabled": false,
          "rpc-host-whitelist": "",
          "rpc-host-whitelist-enabled": true,
          "rpc-password": "{49bb79d45880e81d2d8efc5c19f2fdd39549e1bbaSOz46ih",
          "rpc-port": 9091,
          "rpc-url": "/transmission/",
          "rpc-username": "",
          "rpc-whitelist": "127.0.0.1",
          "rpc-whitelist-enabled": true,
          "scrape-paused-torrents-enabled": true,
          "script-torrent-done-enabled": false,
          "script-torrent-done-filename": "/home/pholi",
          "script-torrent-done-seeding-enabled": false,
          "script-torrent-done-seeding-filename": "",
          "seed-queue-enabled": false,
          "seed-queue-size": 10,
          "show-backup-trackers": false,
          "show-extra-peer-details": false,
          "show-filterbar": true,
          "show-notification-area-icon": false,
          "show-options-window": true,
          "show-statusbar": true,
          "show-toolbar": true,
          "show-tracker-scrapes": false,
          "sort-mode": "sort-by-id",
          "sort-reversed": false,
          "speed-limit-down": 100,
          "speed-limit-down-enabled": false,
          "speed-limit-up": 0,
          "speed-limit-up-enabled": true,
          "start-added-torrents": true,
          "start-minimized": false,
          "statusbar-stats": "total-ratio",
          "torrent-added-notification-enabled": false,
          "torrent-complete-notification-enabled": false,
          "torrent-complete-sound-command": [
              "canberra-gtk-play",
              "-i",
              "complete-download",
              "-d",
              "transmission torrent downloaded"
          ],
          "torrent-complete-sound-enabled": false,
          "trash-can-enabled": true,
          "trash-original-torrent-files": false,
          "umask": 18,
          "upload-slots-per-torrent": 14,
          "user-has-given-informed-consent": true,
          "utp-enabled": true,
          "watch-dir": "/home/pholi/torrents",
          "watch-dir-enabled": true
                           }
    '';
    
    persistence."/nosnap/home/${username}" = {
      directories = [
        ".cache/transmission"
      ];
    };
  };
}
