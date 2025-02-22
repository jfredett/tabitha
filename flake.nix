{
    description = "Tabitha, a tree-sitter based Rust Code Exploration and Diagramming Tool";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        # BUG: Devenv captures all code in a repo and ships it to an external server owned by Devenv.
        # Even if you opt out, it still sends the code, but just marks it not to be used for 'telemetry'.
        # This is so profoundly stupid it can only be malicious.
        # This commit is before the telemetry was added.
        # see: https://github.com/cachix/devenv/blob/1235cd13f47df6ad19c8a183c6eabc1facb7c399/devenv/src/devenv.rs#L214
        #
        # Shame on you, Devenv guy. Shame.
        devenv.url = "github:jfredett/devenv";
    };

    outputs = { self, nixpkgs, devenv, flake-utils } @ inputs: let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
    in {
        packages.${system} = {
            devenv-up = self.devShells.${system}.default.config.procfileScript;
            ci = pkgs.writeShellApplication {
                name = "ci";

                runtimeInputs = with pkgs; [ 
                    ruby_3_4
                    just
                    bundler
                ];

                text = /* bash */ ''
                    if [ -d .parsers ]; then
                        rm .parsers/*
                    else
                        mkdir -p .parsers
                    fi
                    ln -s "${pkgs.tree-sitter-grammars.tree-sitter-rust}/parser" .parsers/rust.so
                    ln -s "${pkgs.tree-sitter-grammars.tree-sitter-rust}/queries" .parsers/rust_queries

                    just ci
                '';
            };
        };

        devShells.${system}.default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [{
                languages.ruby = {
                    enable = true;
                    bundler.enable = true;
                    package = pkgs.ruby_3_4;
                };

                enterShell = /* bash */ ''
                    if [ -d .parsers ]; then
                        rm .parsers/*
                    else
                        mkdir -p .parsers
                    fi
                    ln -s "${pkgs.tree-sitter-grammars.tree-sitter-rust}/parser" .parsers/rust.so
                    ln -s "${pkgs.tree-sitter-grammars.tree-sitter-rust}/queries" .parsers/rust_queries
                '';

                packages = with pkgs; [
                    cloc
                    gnuplot
                    plantuml
                    just
                ];
            }];
        };
    };
}
    # outputs = { self, nixpkgs, devenv, ... } @ inputs: let
    #     systems = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    #     forAllSystems = f: builtins.listToAttrs (map (name: { inherit name; value = f name; }) systems);
    # in  forAllSystems (system: let
    #         pkgs = import nixpkgs { inherit system; };
    #     in {
    #         packages.${system}.devenv-up = self.devShells.${system}.default.config.procfileScript;


    #         devShells.${system}.default = devenv.lib.mkShell {
    #             inherit inputs pkgs;

    #             modules = [{
    #                 languages.ruby = {
    #                     enable = true;
    #                     bundler.enable = true;
    #                     package = pkgs.ruby_3_4;
    #                 };

    #                 enterShell = /* bash */ ''
    #                     if [ -d .parsers ]; then
    #                         rm .parsers/*
    #                     else
    #                         mkdir -p .parsers
    #                     fi
    #                     ln -s "${pkgs.tree-sitter-grammars.tree-sitter-rust}/parser" .parsers/rust.so
    #                     ln -s "${pkgs.tree-sitter-grammars.tree-sitter-rust}/queries" .parsers/rust_queries
    #                 '';

    #                 packages = with pkgs; [
    #                     cloc
    #                     gnuplot
    #                     plantuml
    #                     just
    #                 ];
    #             }];
    #         };
    #     });
