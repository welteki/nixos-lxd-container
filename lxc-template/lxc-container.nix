{ lib, config, pkgs, ... }:

with lib;

{
  # This is container
  boot.isContainer = true;
  boot.loader.initScript.enable = true;

  # Disable systemd-udev-trigger.service in lxc containers
  systemd.services.systemd-udev-trigger.enable = false;

  # Add the overrides from lxd distrobuilder
  systemd.extraConfig = ''
    [Service]
    ProtectProc=default
    ProtectControlGroups=no
    ProtectKernelTunables=no
  '';

  # Network
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  # Support for flakes and deploy-rs
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];   # support for flake config
    trusted-users = [ "root" "admin" ];       # this users can build nixos, need for deploy-rs
  };

  # /etc/passwd is imutable
  users.mutableUsers = false;

  users.users.admin = {
    isNormalUser = true;
    description = "Administrator";
    extraGroups = [ "wheel" ];
    uid = 1000;
    password = "nixos";
  };

  # Passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  # Containers should be light-weight, so start sshd on demand.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    openFirewall = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
    startWhenNeeded  = true;
  };

  services.getty.autologinUser = lib.mkDefault "root";

  system.stateVersion = "22.11";
}
