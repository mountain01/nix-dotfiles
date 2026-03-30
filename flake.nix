{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }:
  let
    username = "mattedwards";
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Matts-MacBook-Pro
    darwinConfigurations."Matts-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        home-manager.darwinModules.home-manager
        ./darwin.nix

        ({config, pkgs, ...}@args: {
          home-manager.users.${username} = import ./home/home.nix (args // {inherit username;});
        } )
      ];
      specialArgs = { inherit self username ; };
    };
  };
}
