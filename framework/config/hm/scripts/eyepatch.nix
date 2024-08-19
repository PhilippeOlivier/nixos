{
  pkgs
, eyepatchDirectory
, username
, ...
}:

let
  eyepatch-script = pkgs.writeShellScriptBin "eyepatch-script" ''
    tpb_names() {
        # Finds TPB torrent names associated with the search terms.
        # Args:
        #   $1: Search terms.
        # Returns:
        #   List of names of torrents associated with the results of the search terms.
        # Usage:
        #   tpb_names "only murders in the building s02e04"
        local terms_raw="$1"
        # Putting the search terms in lowercase mitigates interference from Cloudflare.
        local terms_sep_space=$(echo "$terms_raw" | tr [:upper:] [:lower:])
        terms_sep_percentage20="''${terms_sep_space// /%20}"
        local results=$(${pkgs.curl}/bin/curl -s "https://apibay.org/q.php?q={$terms_sep_percentage20}&cat=")
        # If Cloudflare blocks the search, don't parse the results with `jq`.
        if echo "$results" | ${pkgs.gnugrep}/bin/grep -qi "cloudflare"; then
            results="cloudflare"
        else
            results="$(echo $results | ${pkgs.jq}/bin/jq .[].name)"
        fi
        echo "$results"
    }

    echo $(tpb_names "only murders in the building s02e04")
  '';
in

{  
  sops.secrets.ntfyTopic = {};
  
  systemd.user.services."eyepatch" = {
    Unit = {
      Description = "Check for new episodes with Eyepatch";
    };
    Install.WantedBy = [ "default.target" ];
    Service = {
      Type = "oneshot";
      ExecStart = "${eyepatch-script}/bin/eyepatch-script";
    };
  };
  
  systemd.user.timers."eyepatch" = {
    Install.WantedBy = [ "timers.target" ];
    Timer = {
      Unit = "eyepatch.service";
      OnCalendar = "*-*-* 3:00:00";
      Persistent = true;
    };
  };

  home = {
    persistence = {
      "/snap/home/${username}" = {
        directories = [
          eyepatchDirectory
        ];
      };
    };
  };
}