{
  inputs = {
    fenix.url = "github:nix-community/fenix";
    # ravedude.url = "github:Rahix/avr-hal?dir=ravedude";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs, fenix }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ fenix.overlays.default ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.pkgsCross.avr.buildPackages.gcc
          pkgs.avrdude
          pkgs.ravedude
          # ravedude.defaultPackage.${system}
          (pkgs.fenix.fromToolchainFile {
            file = ./rust-toolchain.toml;
            sha256 = "DnyK5MS+xYySA+csnnMogu2gtEfyiy10W0ATmAvmjGg=";
          })
        ];
      };
    };
}
