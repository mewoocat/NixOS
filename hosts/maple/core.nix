{
  config,
  lib,
  pkgs,
  ...
}: {

  users.users.eXia = {
    isNormalUser = true;
    extraGroups = ["wheel" "video"]; # Enable ‘sudo’ for the user.
    hashedPasword = "$y$j9T$jE3Q.FO.9njaFg.12kpkj/$LUmRsPqolNDMt2pJk8a0L08cK9ixebyOHIbaSx8RQr3";
    # Set ssh public keys
    authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGEq87GVNHxQ79oWb5qt9RBUmTlViOLUDl2BFtouehl3 eXia@obsidian"
    ];
    packages = with pkgs; [
    ];
  };

}
