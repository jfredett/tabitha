
test *ARGS:
    bundle exec rspec spec {{ARGS}}

ci:
    bundle install
    bundle exec rspec spec/

cloc *args:
  cloc --vcs=git --exclude-ext=.rc . {{args}}

taghunt:
    @just _taghunt "BUG" "FIXME" "HACK" "NOTE" "TODO" "OQ"

_taghunt *TAGS:
    #!/usr/bin/env bash
    for tag in {{TAGS}}; do
        echo -n "$tag=$(rg --glob \!Justfile $tag . | wc -l)<br/>"
    done
    echo

