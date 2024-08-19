{
  config
, pkgs
, hnDirectory
, homeDirectory
, username
, ...
}:

let
  hn-script = pkgs.writeShellScriptBin "hn2-script" ''
    # https://github.com/HackerNews/API
    # https://hacker-news.firebaseio.com/v0/maxitem.json <-- this is the latest item on HN
    # Example: https://hacker-news.firebaseio.com/v0/item/123423.json

    # One item id per line representing a comment that matches the terms
    MATCH_FILE="${homeDirectory}/${hnDirectory}/matches.log"

    # One item id per line representing a whoishiring (user) submission that is now out of date (older
    # than 3 weeks), so it needs not be checked again
    OLD_SUBMISSIONS="${homeDirectory}/${hnDirectory}/submissions.log"

    # One item id per line representing a comment to a "Who's Hiring?" submission that has already been
    # processed, so it needs not be checked again
    JOBS_PROCESSED="${homeDirectory}/${hnDirectory}/jobs.log"

    # Regex terms to seach for (case-insensitive)
    # Note: Make sure to put more important terms earlier
    TERMS=("mathematical model"
           "mathematical program")

    # Make sure the files exist
    ${pkgs.coreutils}/bin/touch {"$MATCH_FILE","$OLD_SUBMISSIONS","$JOBS_PROCESSED"}

    # Check for any whoishiring (user) submissions that are not yet too old
    wih="$(${pkgs.curl}/bin/curl -sL https://hacker-news.firebaseio.com/v0/user/whoishiring.json)"
    wih_submissions="$(echo "$wih" | ${pkgs.jq}/bin/jq ".submitted" | ${pkgs.jq}/bin/jq -r ".[]")"
    active_submissions=()
    for submission in $wih_submissions; do
        # If the submission is not yet marked as old
        if ! ${pkgs.gnugrep}/bin/grep -qx "$submission" "$OLD_SUBMISSIONS"; then
            # Check how old it is
            submission_time="$(${pkgs.curl}/bin/curl -sL "https://hacker-news.firebaseio.com/v0/item/''${submission}.json" | ${pkgs.jq}/bin/jq ".time")"
            current_time="$(${pkgs.coreutils}/bin/date +%s)"
            elapsed=$((current_time-submission_time))
            # If it is too old, add it to the old submissions, otherwise add it to the list
            if [[ elapsed -gt 1814400 ]]; then
                echo "Submission $submission is too old ($(${pkgs.coreutils}/bin/date -d "@$submission_time"))"
                echo "$submission" >> "$OLD_SUBMISSIONS"
            else
                active_submissions[''${#active_submissions[@]}]="$submission"
            fi
        fi
    done

    # Process each active submission
    for active_submission in "$active_submissions[@]"; do
        # Get the item ids of all the responses to that submission
        asub_json="$(${pkgs.curl}/bin/curl -sL "https://hacker-news.firebaseio.com/v0/item/''${active_submission}.json")"
        responses="$(echo "$asub_json" | ${pkgs.jq}/bin/jq ".kids" | ${pkgs.jq}/bin/jq -r ".[]")"
        for response in $responses; do
            if ${pkgs.gnugrep}/bin/grep -qx "$response" "$JOBS_PROCESSED"; then
                echo "The response $response has already been processed"
            else
                echo "Processing response $response"
                response_json="$(${pkgs.curl}/bin/curl -sL "https://hacker-news.firebaseio.com/v0/item/''${response}.json")"
                response_text="$(echo "$response_json" | ${pkgs.jq}/bin/jq ".text")"
                # Check if any search terms apply
                for term in "''${TERMS[@]}"; do
                    if echo "$response_text" | ${pkgs.gnugrep}/bin/grep -is "$term"; then
                        echo "Response $response has a match!"
                        url="https://news.ycombinator.com/item?id=$response"
                        ${pkgs.curl}/bin/curl -d "[$term] $url" ntfy.sh/pholi-homelab
                        echo "[$(${pkgs.coreutils}/bin/date "+%Y-%m-%d %-H:%M")] [$term] $url" >> "$MATCH_FILE"
                        break
                    fi
                done
                echo "$response" >> "$JOBS_PROCESSED"
            fi
        done
    done
  '';

in

{  
  sops.secrets.ntfyTopic = {};
  
  systemd.user.services."hn" = {
    Unit = {
      Description = "Check for interesting replies to whoshiring on HN";
    };
    Install.WantedBy = [ "default.target" ];
    Service = {
      Type = "oneshot";
      ExecStart = "${hn-script}/bin/hn-script";
    };
  };
  
  systemd.user.timers."hn" = {
    Install.WantedBy = [ "timers.target" ];
    Timer = {
      Unit = "hn.service";
      OnCalendar = "*-*-* 3:00:00";
      Persistent = true;
    };
  };

  home = {
    persistence = {
      "/snap/home/${username}" = {
        directories = [
          hnDirectory
        ];
      };
    };
  };
}
