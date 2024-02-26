{ config, pkgs, ... }:

{
  # To view HTML emails in the browser
  home = {
    packages = with pkgs; [
      mailcap
    ];
    file.".mailcap".text = ''
      text/html; firefox %s
      application/pdf; imv %s
    '';
    file.".mbsync".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nixos-extra/mail/mbsync";
  };
  
  programs.mbsync = {
    enable = true;
    extraConfig = ''
      Sync All
      Create Near
      Remove None
      Expunge None
      SyncState *
    '';
  };

  programs.msmtp.enable = true;

  programs.notmuch.enable = true;

  services.mbsync = {
    enable = true;
    frequency = "*-01-01 00:00:00";  # Once a year, i.e., never (because `.nixos-extra/scripts/mail/fetch.sh` can let us know if there is an error with a mailbox)
  };
  
  accounts.email = {
    maildirBasePath = ".nixos-extra/mail/maildirs";
    certificatesFile = /etc/ssl/certs/ca-certificates.crt;
    accounts = {
      "pedtsr" = {
        folders = {
          inbox = "inbox";
          sent = "sent";
        };
        primary = true;
        address = "philippe@pedtsr.ca";
        userName = "philippe@pedtsr.ca";
        realName = "Philippe Olivier";
        passwordCommand = "${pkgs.gnupg}/bin/gpg --quiet --for-your-eyes-only --no-tty --decrypt /home/pholi/.nixos-extra/mail/passwords/pedtsr.gpg";
        imap = {
          host = "ajax.canspace.ca";
          tls.useStartTls = true;
        };
        smtp = {
          host = "ajax.canspace.ca";
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
      "polymtl" = {
        folders = {
          inbox = "inbox";
          sent = "sent";
        };
        primary = false;
        address = "philippe.olivier@polymtl.ca";
        userName = "pholi";
        realName = "Philippe Olivier";
        passwordCommand = "${pkgs.gnupg}/bin/gpg --quiet --for-your-eyes-only --no-tty --decrypt /home/pholi/.nixos-extra/mail/passwords/polymtl.gpg";
        imap = {
          host = "imap.polymtl.ca";
          tls.useStartTls = true;
        };
        smtp = {
          host = "smtp.polymtl.ca";
          port = 587;
          tls.useStartTls = false;
        };
        mbsync = {
          enable = true;
          create = "maildir";
          expunge = "none";
          remove = "none";
          groups = {
            "polymtl" = {
              channels = {
                "inbox" = {
                  patterns = ["INBOX"];
                };
                "sent" = {
                  farPattern = "Sent";
                  nearPattern = "sent";
                };
                "spam" = {
                  farPattern = "Polluriel";
                  nearPattern = "spam";
                };
              };
            };
          };
        };
        msmtp = {
          enable = true;
          extraConfig = {
            tls_starttls = "on";
          };
        };
        notmuch.enable = true;
      };
    };
  };
}
