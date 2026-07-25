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
    {
      darwinConfigurations."Kota-UsuhaMacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [ ./darwin-configuration.nix ];
      };

      checks.aarch64-darwin.system = self.darwinConfigurations."Kota-UsuhaMacBook-Pro".system;
    };
}
