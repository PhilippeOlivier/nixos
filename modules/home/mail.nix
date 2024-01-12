{ config, pkgs, ... }:

{
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  # programs.notmuch.enable = true;

  services.mbsync = {
    enable = true;
    frequency = "48hr";
  };
  
  accounts.email = {
    maildirBasePath = ".nixos-extra/mail/mail";
    certificatesFile = /etc/ssl/certs/ca-certificates.crt;
    accounts = {
      "pedtsr" = {
        primary = true;
        address = "nixos@pedtsr.ca";
        userName = "nixos@pedtsr.ca";
        realName = "Philippe Olivier Nixos";
        passwordCommand = "${pkgs.gnupg}/bin/gpg --quiet --for-your-eyes-only --no-tty --decrypt /home/pholi/.nixos-extra/mail/pedtsr.gpg";
        imap = {
          host = "ajax.canspace.ca";  # replace with mail.pedtsr.ca?
          port = 993;
          tls.useStartTls = true;
        };
        smtp = {
          host = "ajax.canspace.ca";  # replace with mail.pedtsr.ca?
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
                  farPattern = "INBOX";
                  nearPattern = "pedtsr/inbox";
                  # TODO: make the gpg pw file on the old laptop and transfer it here
                };
                "sent" = {
                  farPattern = "Sent";
                  nearPattern = "pedtsr/sent";
                };
                "spam" = {
                  farPattern = "spam";
                  nearPattern = "pedtsr/spam";
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
