{...}: {
  services.declarative-jellyfin = {
    enable = true;

    Users = {
      Admin = {
        Mutable = false;
        Password = "123";
        Permissions = {
          IsAdministrator = true;
        };
      };
      Alice = {
        Mutable = false;
        HashedPassword = builtins.readFile ../tests/example_hash.txt;
        Permissions = {
          IsAdministrator = true;
        };
      };
      Bob = {
        Mutable = false;
        HashedPasswordFile = ../tests/example_hash.txt;
        Permissions = {
          IsAdministrator = false;
        };
      };
    };

    apikeys = {
      Jellyseerr = {
        key = "78878bf9fc654ff78ae332c63de5aeb6";
      };
      Homarr = {
        keyPath = ../tests/example_apikey.txt;
      };
    };

    # TODO: add more
  };
}
