FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /penelope
WORKDIR /penelope
ADD Gemfile /penelope/Gemfile
ADD Gemfile.lock /penelope/Gemfile.lock
RUN bundle install
ADD . /penelope

