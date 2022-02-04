FROM 276018124710.dkr.ecr.eu-west-1.amazonaws.com/fullstaq-ruby:3.0.3-jemalloc
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y curl build-essential git \
  && curl -sL https://deb.nodesource.com/setup_17.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g npm

WORKDIR /code
COPY . /code

RUN npm ci && npm run lint && rm -rf node_modules

RUN gem install bundler
RUN bundle install

RUN bundle exec rake build
