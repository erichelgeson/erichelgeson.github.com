{
  description = "Jekyll blog - erichelgeson.github.com";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            ruby_3_3
            bundler
            rubyPackages_3_3.jekyll
            # Build dependencies
            pkg-config
            libffi
            zlib
            libyaml
          ];

          shellHook = ''
            export GEM_HOME="$PWD/.gem"
            export PATH="$GEM_HOME/bin:$PATH"
            export BUNDLE_PATH="$PWD/.bundle"
            echo "Jekyll development environment ready!"
            echo "Run 'bundle install' then 'bundle exec jekyll serve' to start"
          '';
        };

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "erichelgeson-blog";
          version = "1.0.0";
          src = ./.;

          buildInputs = with pkgs; [
            ruby_3_3
            rubyPackages_3_3.jekyll
          ];

          buildPhase = ''
            export HOME=$TMPDIR
            export GEM_HOME=$TMPDIR/.gem
            jekyll build
          '';

          installPhase = ''
            cp -r _site $out
          '';
        };
      }
    );
}
