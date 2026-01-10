{ ... }: {
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"

      "mqtt"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      # This is needed to load in the dependencies for the default integrations
      default_config = {};

      mqtt = {
      };
    };
  };

  # The Home Assistant add-ons are not supported by the NixOS module, so we can't use the 
  # recommended mosquitto broker add-on, need to set it up manually here
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        port = 1883; # Non TLS
        address = "0.0.0.0"; # Accept connection from any address
        #acl = [ "pattern readwrite #"]; # Allow any user to read and write anything (I think)
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
        users = {
          "root" = {
            acl = [
              "readwrite #"
            ];
            password = "1234";
          };
        };
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 
    1883 # MQTT
    8123 # Home Assistant web client
  ];
}
