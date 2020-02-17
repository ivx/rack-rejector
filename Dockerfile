FROM quay.io/invisionag/fullstaq-ruby:2.7.0-jemalloc

ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y curl build-essential git \
  && curl -sL https://deb.nodesource.com/setup_13.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g yarn

WORKDIR /code
COPY . /code

RUN yarn install
RUN yarn lint

RUN gem install bundler
RUN bundle install

RUN bundle exec rake build
