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
        Password = "456";
        Permissions = {
          IsAdministrator = true;
        };
      };
      Bob = {
        Mutable = false;
        Password = "789";
        Permissions = {
          IsAdministrator = false;
        };
      };
    };

    # TODO: add more
  };
}
