
test *ARGS:
    bundle exec rspec spec {{ARGS}}

ci:
    bundle install
    bundle exec rspec spec/
