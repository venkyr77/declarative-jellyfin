{...}: {
  services.declarative-jellyfin = {
    enable = true;

    libraries = {
      Movies = {
        Enabled = true;
        ContentType = "movies";
        PathInfos = ["/data/Movies"];
      };
      Shows = {
        Enabled = true;
        ContentType = "tvshows";
        PathInfos = ["/data/Shows"];
      };
      "Photos and videos" = {
        Enabled = true;
        ContentType = "homevideos";
        PathInfos = ["/data/Pictures" "/data/Videos"];
      };
      Books = {
        Enabled = true;
        ContentType = "books";
        PathInfos = ["/data/Books"];
      };
      Music = {
        Enabled = true;
        ContentType = "music";
        PathInfos = ["/data/Music"];
      };
    };

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
        Preferences = {
          # Only allow access to photos and music
          EnabledLibraries = [ "Photos and Videos" "Music" ];
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

  # This is just for making sure the library paths exists, you dont need this
  system.activationScripts.setupFolders =
    /*
    bash
    */
    ''
      mkdir -p /data/Movies
      mkdir -p /data/Shows
      mkdir -p /data/Pictures
      mkdir -p /data/Videos
      mkdir -p /data/Books
      mkdir -p /data/Music
    '';
}
