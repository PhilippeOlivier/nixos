{
  pkgs
, eyepatchDirectory
, homeDirectory
, username
, ...
}:

let
  eyepatch-script = pkgs.writeShellScriptBin "eyepatch-script" ''
    track_file="${homeDirectory}/${eyepatchDirectory}/track"
    log_file="${homeDirectory}/${eyepatchDirectory}/log"

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

    is_series_tracked() {
        # Checks if a series is tracked by this script (i.e., does not have a "0 0" season-episode pair).
        # Args:
        #   $1: Series.
        # Returns:
        #   True if the series is tracked, false otherwise.
        if ${pkgs.gnugrep}/bin/grep -qiE "^$1 [1-9][0-9]? [1-9][0-9]?$" "$track_file"; then
            true
        else
            false
        fi
    }

    series_exists() {
        # Checks if a series actually exists.
        # Args:
        #   $1: Series.
        # Returns:
        #   True if the series exists, false otherwise.
        episode_exists "$1" "1" "1"
    }

    latest_tracked_season() {
        # Returns the latest season of a series that has been actively tracked.
        # Args:
        #   $1: Series.
        if ! is_series_tracked "$1"; then
            echo "Error: Series \"$(make_title "$1")\" is not tracked."
            exit 0
        fi
        local latest_season="$(${pkgs.gnugrep}/bin/grep -iE "^$1 [1-9][0-9]? [1-9][0-9]?$" $track_file | ${pkgs.coreutils}/bin/rev | ${pkgs.coreutils}/bin/cut -d ' ' -f2 | ${pkgs.coreutils}/bin/rev)"
        echo "$latest_season"
    }

    latest_tracked_episode() {
        # Returns the latest episode of a series that has been actively tracked.
        # Args:
        #   $1: Series.
        if ! is_series_tracked "$1"; then
            echo "Error: Series \"$(make_title "$1")\" is not tracked."
            exit 0
        fi
        local latest_episode="$(${pkgs.gnugrep}/bin/grep -iE "^$1 [1-9][0-9]? [1-9][0-9]?$" $track_file | ${pkgs.coreutils}/bin/rev | ${pkgs.coreutils}/bin/cut -d ' ' -f1 | ${pkgs.coreutils}/bin/rev)"
        echo "$latest_episode"
    }

    get_series_from_line() {
        # Extract the series name from a line of `track_file`.
        # Args:
        #   $1: One whole line of `track_file`.
        echo "$1" | ${pkgs.gnused}/bin/sed -E 's/^([[:print:]]*) ([1-9][0-9]? [1-9][0-9]?|0 0)$/\1/'
    }

    update_series_status() {
        # Update a series status.
        # Args:
        #   $1: Series.
        #   $2: Season.
        #   $3: Episode.
        # The result will be to replace the series line in `track_file` with $1 $2 $3.
        ${pkgs.gnused}/bin/sed -Ei "s/^$1 ([0-9][0-9]? [0-9][0-9]?|0 0)$/$1 $2 $3/" "$track_file"
        # Log all changes.
        echo "[$(${pkgs.coreutils}/bin/date +%Y-%m-%d)] $(make_title "$1") S$(d_to_dd "$2")E$(d_to_dd "$3")" >> "$log_file"
    }

    series_has_new_episode() {
        # Checks for one next new episode of the series, and updates the tracking file accordingly.
        # Args:
        #   $1: Series.
        # Return:
        #   True if a new episode has been found, false otherwise.
    
        local series="$1"

        # If the series is untracked, check if the first episode exists. If yes, start actively tracking
        # the series starting at S01E01. If the series is already tracked, check for new episodes.
        if ! series_exists "$series"; then
            echo "Series not found"
            false
        elif ! is_series_tracked "$series"; then
            # If the first episode of the series exists, start tracking the episodes.
            if episode_exists "$series" "1" "1"; then
                echo "New episode: S01E01"
                update_series_status "$series" "1" "1"
                true
            fi
        else
            local season="$(latest_tracked_season "$series")"
            local episode="$(latest_tracked_episode "$series")"
            # Check for a new episode in the current season. If it fails, check for episode 1 of the
            # next season.
            if episode_exists "$series" "$season" "$(( episode + 1 ))"; then
                echo "New episode: S$(d_to_dd "$season")E$(d_to_dd "$(( episode + 1 ))")"
                update_series_status "$series" "$season" "$(( episode + 1 ))"
                true
            elif episode_exists "$series" "$(( season + 1 ))" "1"; then
                echo "New episode: S$(d_to_dd "$(( season + 1 ))")E01"
                update_series_status "$series" "$(( season + 1 ))" "1"
                true
            else
                echo "No new episodes"
                false
            fi
        fi
    }

    notify() {
        # Sends a notification for series tracking status in `track_file`.
        # Args:
        #   $1: Series.
        local series="$1"
        local season="$(latest_tracked_season "$series")"
        local episode="$(latest_tracked_episode "$series")"
        ${pkgs.curl}/bin/curl -d "New episode: $(make_title "$series") S$(d_to_dd "$season")E$(d_to_dd "$episode")" ntfy.sh/pholi-homelab
    }

    init

    while read line; do
        echo line=$line
        series=$(get_series_from_line "$line")
        echo series=$series
        # echo "Searching for new episodes for series: $(make_title "$series")"
        # while series_has_new_episode "$series"; do
        #     notify "$series"
        #     ${pkgs.coreutils}/bin/sleep 5  # Make sure not to spam TPB so as to not get the IP banned
        # done
    done < "$track_file"
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
