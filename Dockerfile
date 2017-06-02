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
    # cleanup
    && rm -rf /var/lib/apt/lists/*

# install nodejs
RUN \
  cd /tmp && \
  wget http://nodejs.org/dist/node-latest.tar.gz && \
  tar xvzf node-latest.tar.gz && \
  rm -f node-latest.tar.gz && \
  cd node-v* && \
  ./configure && \
  CXX="g++ -Wno-unused-local-typedefs" make && \
  CXX="g++ -Wno-unused-local-typedefs" make install && \
  cd /tmp && \
  rm -rf /tmp/node-v* && \
  npm install -g npm && \
  echo '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc

WORKDIR /
RUN git clone https://github.com/fastlane/boarding.git \
 && cd boarding \
 && bundle install

WORKDIR /boarding
CMD bundle exec puma -C config/puma.rb