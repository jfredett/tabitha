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

            perSystem = { pkgs, system, ...}: let
                ci_deps = with pkgs; [
                    just
                    gcc
                    gnumake
                ];
                dev_deps = with pkgs; ci_deps ++ [
                    cloc
                    gnuplot
                    plantuml
                ];
            in {
                packages.ci = pkgs.writeShellApplication {
                    name = "ci";

                    runtimeInputs = ci_deps;

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

                devshells.default = {extraModulesPath, ...}@args: {
                    motd = "Mischief? I ain't up to no mischief.";

                    imports = ["${extraModulesPath}/language/ruby.nix"];

                    language.ruby.package = pkgs.ruby_3_4;

                    packages = dev_deps;

                    commands = [
                        {
                            name = "get-parsers";
                            category = "util";
                            help = "Fetch the treesitter parser for Rust from nixpkgs";
                            command = /* bash */ ''
                                if [ -d .parsers ]; then
                                    rm .parsers/*
                                else
                                    mkdir -p .parsers
                                fi
                                ln -s "${pkgs.tree-sitter-grammars.tree-sitter-rust}/parser" .parsers/rust.so
                                ln -s "${pkgs.tree-sitter-grammars.tree-sitter-rust}/queries" .parsers/rust_queries
                            '';
                        }

                    ];
                };
            };
        };
}
