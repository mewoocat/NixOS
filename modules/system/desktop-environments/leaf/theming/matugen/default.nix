{ config, ... } : {
  hjem.users.${config.username} = {
    clobberFiles = true;
    files = {
      ".config/matugen" = {
        source = ./config;
      };
    };
  };
}
