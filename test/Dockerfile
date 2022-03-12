FROM ruby:3.1.0

# Prepare working directory.
WORKDIR /ror
COPY ./ /ror
RUN gem install bundler
RUN bundle install

# Start app server.
CMD ["./bin/rake", "test"]
