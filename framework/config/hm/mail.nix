{
  config
, pkgs
, email1
, maildirsDirectory
, maildirsPath
, secretsFilePath
, username
, ...
}:

let
  # This script is required instead of `services.mbsync.preExec` and `services.mbsync.postExec`
  # because we need the return code of the command `mbsync`
  mail-fetch-script = "${pkgs.writeShellScriptBin "fetch-mail" ''
    mkdir -p asdf
    #mkdir -p ${maildirsPath}/{${email1}}/{a,b,c}

   #  IFS=$'\n' special_emails=($(${pkgs.findutils}/bin/xargs -n1 <<<"$(${pkgs.coreutils}/bin/cat "${config.sops.secrets.specialEmails.path}")"))
   #  IFS=$'\n' special_terms=($(${pkgs.findutils}/bin/xargs -n1 <<<"$(${pkgs.coreutils}/bin/cat "${config.sops.secrets.specialTerms.path}")"))

   #  echo EMAILS
   #  for email in "''${special_emails[@]}"; do
   #      echo $email
   #  done

   #  echo TERMS
   #  for term in "''${special_terms[@]}"; do
   #      echo $term
   #  done

   #  ${pkgs.isync}/bin/mbsync -V

   # ${pkgs.curl}/bin/curl -d "New mail from: WOO" ntfy.sh/"$(${pkgs.coreutils}/bin/cat "${config.sops.secrets.ntfyTopic.path}")"
  ''}/bin/fetch-mail";
in

{
  accounts.email = {
    maildirBasePath = maildirsDirectory;
    accounts = {
      "${email1}" = {
        folders = {
          inbox = "inbox";
          sent = "sent";
        };
        primary = true;
        address = email1;
        userName = email1;
        realName = "Philippe Olivier";
        passwordCommand = "${pkgs.sops}/bin/sops --decrypt ${secretsFilePath} | ${pkgs.gnugrep}/bin/grep ${email1} | ${pkgs.coreutils}/bin/cut -d' ' -f2";
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
          expunge = "none";
          remove = "none";
          groups = {
            "pedtsr" = {
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
