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
  mail-fetch-script = "${pkgs.writeShellScriptBin "mail-fetch-script" ''
    for mailbox in ${email1}; do
      ${pkgs.isync}/bin/mbsync -V $mailbox
    done
  ''}/bin/mail-fetch-script";
in

{
  programs.mbsync.enable = true;
  
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
            "${email1}" = {
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
