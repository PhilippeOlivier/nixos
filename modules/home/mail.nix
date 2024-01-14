{ config, pkgs, ... }:

{
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  # programs.notmuch.enable = true;

  services.mbsync = {
    enable = true;
    frequency = "48hr";  # TODO: 5 min
    postExec = "";  # TODO: update waybar block, and notmuch routine
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
                  # farPattern = "INBOX";
                  # nearPattern = "pedtsr/inbox";
                  # TODO: make the gpg pw file on the old laptop and transfer it here
                };
                "sent" = {
                  # patterns = ["Sent" "sent"];
                  farPattern = "Sent";
                  nearPattern = "sent";
                };
                "spam" = {
                  farPattern = "spam"; # rename "Junk"?
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
