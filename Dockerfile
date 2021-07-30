FROM 276018124710.dkr.ecr.eu-west-1.amazonaws.com/fullstaq-ruby:3.0.2-jemalloc
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y curl build-essential git \
  && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g yarn

WORKDIR /code
COPY . /code

RUN yarn install
RUN yarn lint

RUN gem install bundler
RUN bundle install

RUN bundle exec rake build
