{...}: {
  # This actually does work :)
  nixpkgs = {
    /*
    config.permittedInsecurePackages = [
      "dotnet-runtime-6.0.36"
      "dotnet-runtime-wrapped-6.0.36"
      "dotnet-sdk-wrapped-6.0.428"
      "dotnet-sdk-6.0.428"
    ];
    */
  };

  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;
}
