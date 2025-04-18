{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "codebook";
  users.users = {
    ievensen = {
      isNormalUser = true;
      initialHashedPassword = "";
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = [ "wheel" "networkmanager" "docker" "video" "audio" "plugdev" ];
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/bluetooth"
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Name = "Computer";
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
      };
      Policy = { AutoEnable = "true"; };
      LE = { EnableAdvMonInterleaveScan = "true"; };
    };
  };

  services = {
    libinput.enable = true;
    blueman.enable = true;
  };
}
