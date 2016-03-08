FROM ruby:2.3.0

RUN apt-get update -qq && apt-get install -y build-essential

# for postgres
RUN apt-get install -y libpq-dev

ENV APP_HOME /home/corse/back
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ENV RAILS_ENV development
ADD . $APP_HOME
RUN bundle install
