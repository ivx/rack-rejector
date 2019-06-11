FROM ruby:2.6.3-slim

RUN apt-get update && apt-get upgrade -y && apt-get install -y build-essential curl git && apt-get -y autoremove && apt-get install libsqlite3-dev

WORKDIR /code

COPY . /code
RUN gem install bundler:2.0.1
RUN bundle install --jobs=4 --retry=3

RUN bundle exec rake build
