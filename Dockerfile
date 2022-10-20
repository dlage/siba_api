FROM ruby:3.0

WORKDIR /usr/src/app

COPY Gemfile .
COPY Gemfile.lock .
COPY siba_api.gemspec .
COPY lib/siba_api/version.rb ./lib/siba_api/version.rb
RUN bundle install

COPY . .
