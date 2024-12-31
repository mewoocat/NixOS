{
  config,
  lib,
  pkgs,
  ...
}: {

  users.users.eXia = {
    isNormalUser = true;
    extraGroups = ["wheel" "video"]; # Enable ‘sudo’ for the user.
    hashedPassword = "$y$j9T$jE3Q.FO.9njaFg.12kpkj/$LUmRsPqolNDMt2pJk8a0L08cK9ixebyOHIbaSx8RQr3";
    # Set ssh public keys
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDXBdJRFkW98CfT+M+NNopY0XOHa2I/zcXA60oQXAtt8paKo+JpmNOadnZXtlHPEQflDz3XntN0Au4sIMHNOBO6KkMcg3Ti1LyVtsi0s6Hw8pB6c6hHZfqx1TxAQyiq8CsUE0eaTY7fDyIiVkL1p9ZR7M4tqrbgh+FVFRJQ0Jb24q85VApxyfzQ+93preM4Vg25gKQBe822jvc+1MW1dt90aYy2Ubz7RRKpGRmnUSvL5qTo++CDDUNvmkVNftyv89hfSikGWERdLNnwTFkbHCZ38cF41zbk8M9X4CKXOfV+DwtErcZjIFU6Xh70t5tpow461FCIWd+I2ekreBlUIDPQhvQ1oiukAvy46ZpoBcyxpBj5nZbtt9ftYzvvIBEQ042042D2PmsKhmT5io7fkPPq4c3Mh9enNdq6zc2PIa/stPDTDSeHxzSMVXpl7yfHfaFZhfRWAmRZ3l1mhuToCqeCkVvm61KgaPSBBsQEPrFsAhW7lLaaedwlR8mvRatmH4k= NixOS anywhere testing"
    ];
    packages = with pkgs; [
    ];
  };

}
