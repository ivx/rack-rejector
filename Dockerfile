FROM quay.io/invisionag/fullstaq-ruby:2.7.0-jemalloc

ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y curl \
  && curl -sL https://deb.nodesource.com/setup_13.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g yarn

WORKDIR /code
COPY . /code

RUN yarn install
RUN yarn lint

FROM quay.io/invisionag/fullstaq-ruby:2.7.0-jemalloc

RUN apt-get update && apt-get upgrade -y && apt-get install -y build-essential git && apt-get -y autoremove

WORKDIR /code

COPY . /code
RUN gem install bundler
RUN bundle install --jobs=4 --retry=3

RUN bundle exec rake build
