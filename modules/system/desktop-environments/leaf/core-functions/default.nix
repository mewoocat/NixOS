{
  pkgs,
  ...
}: let
  wmctl = pkgs.rustPlatform.buildRustPackage rec {
    pname = "wmctl";
    version = "0.0.1";
    src = pkgs.fetchFromGitHub {
      owner = "danyspin97";
      repo = pname;
      rev = "99b649c24d84ccc8b6874f2eeb518813e92250d3";
      sha256 = "sha256-CCN4Umf8b6mla8Xy4YuIjiJAAsfhG12xg8UZhc4wLc8=";
    };    
    nativeBuildInputs = [
      pkgs.pkg-config
    ];
    buildInputs = [
      #pkgs.systemd # For libudev
      pkgs.libxkbcommon
    ];
    cargoHash = "sha256-NihkLYCB1ITT0yl4GbK8noBSnQseDM7nAGqAd386xDs=";
    meta = {
      mainProgram = "wmctl";
    };      
  };
  lumactl = pkgs.callPackage ./lumactl.nix {};
in{
  imports = [
    ./sound.nix
    ./screenlock.nix
    ./startup.nix
  ];

  environment.systemPackages = with pkgs; [
    lumactl
    wmctl
  ];

}
