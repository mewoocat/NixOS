{
  pkgs,
  rustPlatform,
  fetchFromGitHub
}: let
in rustPlatform.buildRustPackage rec {
  pname = "lumactl";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "danyspin97";
    repo = pname;
    rev = "89e273e25afe545e3bcaf282b84a63e3c34117de";
    sha256 = "sha256-PQucBe3xPjjzuiaukdf2f/CvTqbGm0wJMbdpgd2ubnU=";
  };
  
  cargoHash = "sha256-cjXlEn7O4LKal4ZDEbsA8T2AZtyAcELRxhYsC/pVcGs=";

  nativeBuildInputs = [
    pkgs.pkg-config
  ];
  
  buildInputs = [
    pkgs.systemd # For libudev
    pkgs.libxkbcommon
    #wmctl
  ];

  meta = {
    mainProgram = "lumactl";
  };
}
