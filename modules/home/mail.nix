{ config, pkgs, ... }:

{
  programs.mbsync.enable = true;
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
        address = "nixos@pedtsr.ca";
        userName = "nixos@pedtsr.ca";
        realName = "Philippe Olivier Nixos";
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
    };
  };
}
