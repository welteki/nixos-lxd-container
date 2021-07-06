{ lib, config, pkgs, modulesPath, ... }:

with lib;

{
  imports = [
    "${toString modulesPath}/profiles/docker-container.nix"
  ];

  # Disable systemd-udev-trigger.service in lxc containers
  systemd.services.systemd-udev-trigger.enable = false;

  # Add the overrides from lxd distrobuilder
  systemd.extraConfig = ''
    [Service]
    ProtectProc=default
    ProtectControlGroups=no
    ProtectKernelTunables=no
  '';

  # Allow the user to login as root without password.
  users.users.root.initialHashedPassword = mkOverride 150 "";

  system.activationScripts.installInitScript = mkForce ''
    ln -fs $systemConfig/init /sbin/init
  '';

  # Some more help text.
  services.getty.helpLine =
    ''
      Log in as "root" with an empty password.
    '';

  # Containers should be light-weight, so start sshd on demand.
  services.openssh.enable = mkDefault true;
  services.openssh.startWhenNeeded = mkDefault true;
}
