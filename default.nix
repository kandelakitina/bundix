{ pkgs, ruby, bundler, nix, nix-prefetch-git }:

pkgs.stdenv.mkDerivation rec {
  version = "0.0.2";
  name = "bundix";
  src = ./.;

  phases = "installPhase";
  installPhase = ''
    mkdir -p $out
    makeWrapper $src/bin/bundix $out/bin/bundix \
      --prefix PATH : "${nix.out}/bin" \
      --prefix PATH : "${nix-prefetch-git.out}/bin" \
      --prefix PATH : "${bundler.out}/bin" \
      --prefix PATH : "${ruby}/bin" \
      --set GEM_PATH "${bundler}/${bundler.ruby.gemPath}"
  '';

  nativeBuildInputs = [ pkgs.makeWrapper ];
  buildInputs = [ bundler ];

  meta = {
    inherit version;
    description = "Creates Nix packages from Gemfiles";
    longDescription = ''
      This is a tool that converts Gemfile.lock files to nix expressions.

      The output is then usable by the bundlerEnv derivation to list all the
      dependencies of a ruby package.
    '';
    homepage = "https://github.com/sagittaros/bundix";
    license = "MIT";
    maintainers = with pkgs.lib.maintainers; [ manveru zimbatm sagittaros ];
    platforms = pkgs.lib.platforms.all;
  };
}
