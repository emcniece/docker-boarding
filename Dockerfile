FROM ruby:2.2.4
MAINTAINER Eric McNiece <emcniece@gmail.com>

RUN apt-get update -qq && apt-get install -y build-essential \
    # for postgres
    libpq-dev \
    # for nokogiri
    libxml2-dev libxslt1-dev \
    # for capybara-webkit
    libqt4-webkit libqt4-dev xvfb \
    python python-dev python-pip python-virtualenv \
    nodejs \
    # cleanup
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
RUN git clone https://github.com/fastlane/boarding.git \
 && cd boarding \
 && gem install bundler \
 && bundle install

WORKDIR /boarding
CMD bundle exec puma -C config/puma.rb