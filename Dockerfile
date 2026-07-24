FROM ruby:3.1.4-slim

# Fix env for build AND runtime so dev/test-only gems (e.g. the `debug`
# gem's debug/prelude) are never required. Without this, any command that
# runs without RAILS_ENV=production (e.g. db:prepare in the entrypoint)
# boots in development and crashes with:
#   LoadError: cannot load such file -- debug/prelude
ENV RAILS_ENV="production" \
    RACK_ENV="production" \
    BUNDLE_WITHOUT="development:test"

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      nodejs \
      git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

RUN chmod +x bin/docker-entrypoint

EXPOSE 3000
ENTRYPOINT ["bin/docker-entrypoint"]
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000", "-e", "production"]
