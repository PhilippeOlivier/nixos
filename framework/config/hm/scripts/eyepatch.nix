{
  pkgs
, eyepatchDirectory
, username
, ...
}:

let
  eyepatch-script = pkgs.writeShellScriptBin "eyepatch-script2" ''
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
        local terms_sep_space=$(echo "$terms_raw" | ${pkgs.coreutils}/bin/tr [:upper:] [:lower:])
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

    d_to_dd() {
        # Converts a single digit to double digit (e.g., "1" to "01").
        # Has no effect on double digits (even, e.g., "01").
        if [[ $1 -lt 10 ]] && [[ ''${#1} -eq 1 ]]; then
            echo "0$1"
        else
            echo "$1"
        fi
    }

    d_to_dd "1"

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
      ExecStart = "${eyepatch-script}/bin/eyepatch-script2";
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
