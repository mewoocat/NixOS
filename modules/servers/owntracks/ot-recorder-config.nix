{...}: {

  # Create directories that ot-recorder expects to exist
  systemd.tmpfiles.rules = [
    "d /var/spool/owntracks - owntracks users -"
    "d /var/spool/owntracks/recorder - owntracks users -"
    "d /var/spool/owntracks/recorder/htdocs - owntracks users -"
  ];

  environment = { 
    sessionVariables = {
      
    };

    etc = {
      "default/ot-recorder" = {
        text = ''
          #(@)ot-recorder.default
          #
          # Specify global configuration options for the OwnTracks Recorder
          # and its associated utilities to override compiled-in defaults.
          # Lines beginning with # are comments
          # *** In libconfig versions < 1.4 a trailing semicolon is mandatory

          # -----------------------------------------------------
          # Storage directory
          #

          OTR_STORAGEDIR="/var/spool/owntracks/recorder/store"

          # -----------------------------------------------------
          # Address or hostname of the MQTT broker
          #

          OTR_HOST="0.0.0.0"

          # -----------------------------------------------------
          # Port number of the MQTT broker. Defaults to 1883.
          # MQTT can be disabled by setting this to 0.
          #

          OTR_PORT=1883

          # -----------------------------------------------------
          # Username for the MQTT connection
          #

          OTR_USER=""

          # -----------------------------------------------------
          # Password for the MQTT connection
          #

          OTR_PASS=""

          # -----------------------------------------------------
          # QoS for MQTT connection
          #

          OTR_QOS=2

          # -----------------------------------------------------
          # MQTT clientid (default is constant+hostname+pid)
          #

          #OTR_CLIENTID=""

          # -----------------------------------------------------
          # Path to PEM-encoded CA certificate file for MQTT (no default)
          #

          #OTR_CAFILE=""

          # -----------------------------------------------------
          # Address for the HTTP module to bind to (default: localhost)
          # Binding on 0.0.0.0 will listen on IPv4 only
          # Binding on [::] will listen on IPv4 and IPv6
          # OTR_HTTPHOST = "0.0.0.0"
          # OTR_HTTPHOST = "[::]"
          #

          OTR_HTTPHOST="0.0.0.0"

          # -----------------------------------------------------
          # Port number for the HTTP module to bind to (default: 8083)
          #

          OTR_HTTPPORT=8083

          # -----------------------------------------------------
          # optional path to HTTP directory in which to store
          # access log. Default is to not log access
          #

          #OTR_HTTPLOGDIR=""

          # -----------------------------------------------------
          # API key for reverse-geo lookups
          #

          #OTR_GEOKEY=""

          # -----------------------------------------------------
          # Reverse geo precision
          #

          OTR_PRECISION=7

          # -----------------------------------------------------
          # Reverse geo cache expiration time in seconds
          # Purge geo gcache entries after these seconds; default 0, disable with 0
          #

          OTR_CLEAN_AGE=0

          # -----------------------------------------------------
          # Browser API key for Google maps
          #

          #OTR_BROWSERAPIKEY=""

          # -----------------------------------------------------
          # List of topics for MQTT to subscribe to, blank separated in a string
          #

          OTR_TOPICS="owntracks/#"

          # -----------------------------------------------------
          # Optional LUA script which will be loaded with the Recorder
          #

          # OTR_LUASCRIPT="/path/to/script.lua"

          # -----------------------------------------------------
          # HTTP prefix for this recorder for accessing Tour views
          #

          # OTR_HTTPPREFIX="https://owntracks.example/owntracks"
        '';
      };
    };
  };
}
