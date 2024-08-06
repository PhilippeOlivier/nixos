{
  config
, pkgs
, email1
, maildirsDirectory
, maildirsPath
, secretsFilePath
, signalMail
, sopsAgeKeyFilePath
, username
, ...
}:

let
  # This script is required instead of `services.mbsync.preExec` and `services.mbsync.postExec`
  # because we need the return code of the command `mbsync`
  mail-fetch-script = "${pkgs.writeShellScriptBin "mail-fetch-script" ''
    for mailbox in ${email1}; do
        # Create any missing directories
        ${pkgs.coreutils}/bin/mkdir -p ${maildirsPath}/''${mailbox}/{drafts,inbox,sent,spam}/{cur,new,tmp}

        out_file="/tmp/''${mailbox}.out"
        err_file="/tmp/''${mailbox}.err"

        # Remove any previous files
        rm -f "$out_file" "$err_file"

        # Save the outputs of `stdout` and `stderr`
        ${pkgs.isync}/bin/mbsync -V $mailbox 1> "$out_file" 2> "$err_file"

        # If there is anything at all in the error file, there must be an error of some kind
        if [ -s "$err_file" ]; then
            error=1
        else
            error=0
        fi

        # Update the notmuch database
        ${pkgs.notmuch}/bin/notmuch new --quiet &> /dev/null

        # Add the "sent" tags
        ${pkgs.notmuch}/bin/notmuch tag -inbox -unread +sent from:$mailbox

        # Update the status file
        status_file="/tmp/mbsync-status"
        touch $status_file

        # If the entry for the mailbox doesn't exist, create it
        if ! ${pkgs.gnugrep}/bin/grep -q $mailbox $status_file; then
            echo ''${mailbox},$(date +%s),''${error} >> $status_file

        # Otherwise, update it
        else
            ${pkgs.gnused}/bin/sed -i "s/^''${mailbox}.*/''${mailbox},$(date +%s),''${error}/" $status_file
        fi

        # # Update the waybar mail module
        # ${pkgs.procps}/bin/pkill -RTMIN+${signalMail} waybar
    done

    thread_is_unprocessed() {
        # Takes as input a thread, and return 0 if the thread is unprocessed, or 1 if it is

        local thread_number="$(echo "$thread" | sed -E 's/^thread:([0-9a-f]+).*$/\1/')"

        # If the thread is empty (no thread)
        if [ -z "$thread" ]; then
            return 1

        # If the thread has not been processed, send a notification and add the thread number to /tmp
        elif [ ! -f "/tmp/''${thread_number}" ]; then
            return 0
        fi

        return 1
    }

    IFS=$'\n' special_emails=($(${pkgs.findutils}/bin/xargs -n1 <<<"$(${pkgs.coreutils}/bin/cat "${config.sops.secrets.specialEmails.path}")"))

    for sender in "''${special_emails[@]}"; do
        echo "Checking for new unread mail from $sender"
        while read -r thread; do
            if thread_is_unprocessed "$thread"; then
                ${pkgs.curl}/bin/curl -d "New mail from: $sender" ntfy.sh/"$(${pkgs.coreutils}/bin/cat "${config.sops.secrets.ntfyTopic.path}")"
                thread_number="$(echo "$thread" | ${pkgs.gnused}/bin/sed -E 's/^thread:([0-9a-f]+).*$/\1/')"
                touch "/tmp/''${thread_number}"
            fi
        done <<< "$(${pkgs.notmuch}/bin/notmuch search tag:unread from:$sender)"
    done

    IFS=$'\n' special_terms=($(${pkgs.findutils}/bin/xargs -n1 <<<"$(${pkgs.coreutils}/bin/cat "${config.sops.secrets.specialTerms.path}")"))

    for term in "''${special_terms[@]}"; do
        echo "Checking for new unread mail with term $term"
        while read -r thread; do
            if thread_is_unprocessed "$thread"; then
                ${pkgs.curl}/bin/curl -d "New mail with term: $term" ntfy.sh/"$(${pkgs.coreutils}/bin/cat "${config.sops.secrets.ntfyTopic.path}")"
                thread_number="$(echo "$thread" | ${pkgs.gnused}/bin/ -E 's/^thread:([0-9a-f]+).*$/\1/')"
                touch "/tmp/''${thread_number}"
            fi
        done <<< "$(${pkgs.notmuch}/bin/notmuch search tag:unread body:$term)"
    done

  ''}/bin/mail-fetch-script";
in

{
  programs.mbsync = {
    enable = true;
    extraConfig = ''
      # Propagate all changes in both directions
      Sync All

      # Create any missing mailboxes locally
      Create Near

      # Do not propagate mailbox deletions
      Remove None

      # Do not propagate message deletions
      Expunge None

      # Save the synchronization state files `.mbsyncstate` in the local mailbox
      SyncState *
    '';
  };

  programs.msmtp.enable = true;

  programs.notmuch.enable = true;
  
  accounts.email = {
    maildirBasePath = maildirsDirectory;
    accounts = {
      ${email1} = {
        folders = {
          drafts = "drafts";
          inbox = "inbox";
          sent = "sent";
        };
        primary = true;
        address = email1;
        userName = email1;
        realName = "Philippe Olivier";
        passwordCommand = "SOPS_AGE_KEY_FILE=${sopsAgeKeyFilePath} ${pkgs.sops}/bin/sops --decrypt ${secretsFilePath} | ${pkgs.gnugrep}/bin/grep ${email1} | ${pkgs.coreutils}/bin/cut -d' ' -f2";
        imap = {
          host = "mail.pedtsr.ca";
          port = 143;  # Should be 993 ideally, but I can't get it to work
          tls.useStartTls = true;
        };
        smtp = {
          host = "mail.pedtsr.ca";
          port = 465;
          tls.useStartTls = false;
        };
        mbsync = {
          enable = true;
          create = "maildir";
          groups = {
            ${email1} = {
              channels = {
                "inbox" = {
                  patterns = ["INBOX"];
                };
                "sent" = {
                  farPattern = "Sent";
                  nearPattern = "sent";
                };
                "spam" = {
                  farPattern = "spam";
                  nearPattern = "spam";
                };
              };
            };
          };
        };
        msmtp.enable = true;
        notmuch.enable = true;
      };
    };
  };
  
  sops.secrets = {
    specialEmails = {};
    specialTerms = {};
    ntfyTopic = {};
  };
  
  systemd.user.services."fetch-mail" = {
    Unit = {
      Description = "Fetch mail and send ntfy notifications";
    };
    Install.WantedBy = [ "default.target" ];
    Service = {
      Type = "oneshot";
      ExecStart = mail-fetch-script;
    };
  };

  home = {
    packages = with pkgs; [
      mailcap  # To view HTML emails in the browser
    ];
    file.".mailcap".text = ''
      text/html; firefox %s
      application/pdf; zathura %s
    '';

    persistence = {
      "/snap/home/${username}" = {
        allowOther = true;

        directories = [
          maildirsDirectory
          ".mbsync"
        ];
      };
    };
  };
}
