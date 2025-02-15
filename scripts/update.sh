#!@shell@

[ -e ./Gemfile.lock ] && rm ./Gemfile.lock
[ -e ./gemset.nix ] && rm ./gemset.nix

@bundler@ lock

@bundix@ --lock
