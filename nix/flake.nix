{
  description = "Kota's macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-darwin,
      ...
    }:
    let
      localConfig =
        if builtins.pathExists ./local.nix then
          import ./local.nix
        else
          throw "Missing nix/local.nix. Copy nix/local.nix.example and set username.";

      username =
        if localConfig ? username && builtins.isString localConfig.username && localConfig.username != "" then
          localConfig.username
        else
          throw "nix/local.nix must define a non-empty username string.";
    in
    {
      darwinConfigurations."Kota-UsuhaMacBook-Pro" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit username; };
        modules = [ ./darwin-configuration.nix ];
      };

      checks.aarch64-darwin.system = self.darwinConfigurations."Kota-UsuhaMacBook-Pro".system;
    };
}
