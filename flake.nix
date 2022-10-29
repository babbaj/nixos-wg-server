{
  description = "Simple wireguard router server";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators }: {
    packages.x86_64-linux = {
      vpn-server = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "iso";
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
