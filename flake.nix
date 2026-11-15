{
  description = "aurelient's NixOS + home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-desktop = {
      url = "github:poeck/claude-desktop-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Galaxy Book6 SC200PC front camera (local fork of jabbslad/sc200pc-linux).
    # TODO: push the fork to GitHub and use github:<you>/sc200pc-linux/nix-support,
    # otherwise book6 only evaluates on this laptop. Only hosts/book6 uses it.
    sc200pc = {
      url = "git+file:///home/aurelient/repos/sc200pc-linux?ref=nix-support";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      overlays = [ inputs.claude-desktop.overlays.default ];

      # NixOS machine from hosts/<hostname>, with <user> managed by home-manager
      # (core + GUI apps + niri desktop).
      mkHost =
        hostname: user:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs hostname user; };
          modules = [
            ./hosts/${hostname}
            ./users/${user}/nixos.nix
            self.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = overlays;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # Existing unmanaged files are moved to *.bak instead of failing the switch.
              home-manager.backupFileExtension = "bak";
              home-manager.extraSpecialArgs = { inherit inputs hostname user; };
              home-manager.users.${user}.imports = [
                ./users/${user}/home.nix
                ./modules/home/apps
                ./modules/home/desktop
              ];
            }
          ];
        };

      # Standalone home-manager for non-NixOS machines.
      mkHome =
        user: modules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system overlays;
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            inherit inputs user;
            hostname = null;
          };
          modules = [ ./users/${user}/home.nix ] ++ modules;
        };
    in
    {
      # Reusable modules, importable from other flakes.
      nixosModules.default = ./modules/nixos;
      homeModules = {
        core = ./modules/home/core;
        apps = ./modules/home/apps;
        desktop = ./modules/home/desktop;
      };

      nixosConfigurations = {
        book6 = mkHost "book6" "aurelient"; # Galaxy Book6 Pro laptop
        vm = mkHost "vm" "aurelient"; # QEMU test VM / nixos-anywhere target
        desktop = mkHost "desktop" "aurelient"; # main desktop, NVIDIA RTX 3060
      };

      homeConfigurations."aurelient@work" = mkHome "aurelient" [ ./users/aurelient/work.nix ];

      # What CI builds. book6 is left out until the sc200pc input is on GitHub.
      checks.${system} = {
        vm = self.nixosConfigurations.vm.config.system.build.toplevel;
        home-work = self.homeConfigurations."aurelient@work".activationPackage;
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
