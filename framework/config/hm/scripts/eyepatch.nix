{
  pkgs
, eyepatchDirectory
, username
, ...
}:

let
  eyepatch-script = pkgs.writeShellScriptBin "eyepatch-script3" ''

    #TEMP
    track_file="/home/pholi/.config/eyepatch/track"

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

    make_title() {
        # Converts a series name into a title ("only murders in the building" --> "Only Murders In The Building").
        # Args:
        #   $1: Series.
        # Source of this one-liner: https://stackoverflow.com/a/1538818/1725856
        echo "$1" | ${pkgs.gnused}/bin/sed -e "s/\b\(.\)/\u\1/g"
    }

    episode_exists() {
        # Checks if a new episode exists on TPB.
        # Args:
        #   $1: Series.
        #   $2: Season.
        #   $3: Episode.
        # Returns:
        #   True if the episode exists, false otherwise.
        # Usage:
        #   episode_exists "only murders in the building" "2" "4"
        local series="$1"
        local season="$(d_to_dd $2)"
        local episode="$(d_to_dd $3)"
        local names=$(tpb_names "''${series} S''${season}E''${episode}")
        if echo "$names" | ${pkgs.gnugrep}/bin/grep -q "^\"No results returned\"$"; then
            false
        elif echo "$names" | ${pkgs.gnugrep}/bin/grep -qi "cloudflare"; then
            ${pkgs.curl}/bin/curl -d "Error with the \"eyepatch.sh\" script: Cloudflare prevented search for \"$(make_title "''${series}") S''${season}E''${episode}\"." ntfy.sh/pholi-homelab
            false
        else
            # Go through all the names and parse them to mitigate false positives.
            series="$(echo "$series" | ${pkgs.gnused}/bin/sed -E 's/ /./g' )"
            local expression="$series.S''${season}E''${episode}"
            if echo "$names" | ${pkgs.gnugrep}/bin/grep -qi "$expression"; then
                true
            else
                false
            fi
        fi
    }

    init() {
        echo "Script initialization"
    
        # If the tracking file does not exist, return an error.
        if [[ ! -e "$track_file" ]]; then
            ${pkgs.curl}/bin/curl -d "Error with the \"eyepatch.sh\" script: The tracking file does not exist." ntfy.sh/pholi-homelab
            exit 0
        fi
    
        # If the tracking file does not end in a newline, add a newline.
        # Source of this one-liner: https://unix.stackexchange.com/a/31955
        ${pkgs.gnused}/bin/sed -i -e '$a\' "$track_file"
    
        # Check the validity of the format of the entries in the tracking file.
        # Format (season and episode must be 1 or 2 digits each, and not start with 0):
        #   series season episode
        # Note: A series which is not yet released should have "0" for season and "0" for episode.
        # Note: A series which has no season and episode numbers, will be fixed to "0" and "0".
        local format='^.*( [1-9][0-9]? [1-9][0-9]?| 0 0)$'
        while read line; do
            if [[ ! $line =~ $format ]]; then
                ${pkgs.gnused}/bin/sed -i "s/$line/$line 0 0/" "$track_file"
            fi
        done < "$track_file"
    
        # Remove apostrophes (torrent names typically don't have apostrophes).
        while read line; do
            ${pkgs.gnused}/bin/sed -i "s/$line/$(echo "$line" | ${pkgs.coreutils}/bin/tr -d "'")/g" "$track_file"
        done < "$track_file"
        
        # Make sure that TPB works correctly by checking if a popular episode can be found.
        if ! episode_exists "game of thrones" "1" "1"; then
            ${pkgs.curl}/bin/curl -d "Error with the \"eyepatch.sh\" script (TPB is probably down)." ntfy.sh/pholi-homelab
            exit 0
        fi
    }

    init
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
      ExecStart = "${eyepatch-script}/bin/eyepatch-script3";
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
