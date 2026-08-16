{
  description = "Home Manager configuration for aurelient";

  inputs = {
    # nixpkgs' mainline branch is currently named `master`.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      homeConfigurations.aurelient = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./home.nix
        ];
      };
    };
}
