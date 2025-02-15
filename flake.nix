{
    description = "Tabitha, a tree-sitter based Rust Code Exploration and Diagramming Tool";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        devshell.url = "github:numtide/devshell";
        flake-parts.url = "github:hercules-ci/flake-parts";
    };

    outputs = { self, nixpkgs, devshell, flake-parts } @ inputs:

        flake-parts.lib.mkFlake { inherit inputs; } {
            imports = [
                devshell.flakeModule
            ];

            systems = [
                "x86_64-linux"
            ];

            perSystem = { pkgs, system, ... }: {
                packages.ci = pkgs.writeShellApplication {
                    name = "ci";

                    runtimeInputs = with pkgs; [ 
                        bundler
                        gnuplot
                        just
                        plantuml
                        ruby_3_4
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


                devshells.default = let
                    ruby-env = pkgs.bundlerEnv {
                        name = "tabitha";
                        gemdir = ./.;
                        ruby = pkgs.ruby_3_4;
                        inherit (pkgs) bundler;
                    };
                    updateDeps = pkgs.writeScriptBin "update-deps" (builtins.readFile (pkgs.substituteAll {
                        src = ./scripts/update.sh;
                        bundix = "${pkgs.bundix}/bin/bundix";
                        bundler = "${ruby-env.bundler}/bin/bundler";
                    }));
                in {
                    motd = "Mischief? I ain't up to no mischief.";

                    devshell.startup.get-parsers.text = /* bash */ ''
                        if [ -d .parsers ]; then
                            rm .parsers/*
                        else
                            mkdir -p .parsers
                        fi

                        ln -s "${pkgs.tree-sitter-grammars.tree-sitter-rust}/parser" .parsers/rust.so
                        ln -s "${pkgs.tree-sitter-grammars.tree-sitter-rust}/queries" .parsers/rust_queries
                    '';

                    packages = with pkgs; [
                        curl
                        cloc
                        gnuplot
                        just
                        plantuml
                        ruby-env
                        ruby-env.wrappedRuby
                        updateDeps
                        tree-sitter-grammars.tree-sitter-rust
                    ];
                };
            };
        };
}
