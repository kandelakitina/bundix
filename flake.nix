# © 2023 Felix <zen9.felix@gmail.com>

{
  description =
    "A formatter for Nix code, intended to easily apply a uniform style.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) callPackage ruby;
      in {
        packages = rec {
          default = bundix;
          bundix = callPackage ./default.nix { inherit ruby; };
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.bundix}/bin/bundix";
        };
      });
}
