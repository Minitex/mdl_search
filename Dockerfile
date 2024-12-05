FROM ruby:3.3.5
LABEL maintainer="fenne035@umn.edu"

# Stolen from https://github.com/jfroom/docker-compose-rails-selenium-example

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash \
  && apt-get update && apt-get install -qq -y --no-install-recommends \
  build-essential nodejs \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get install apt-transport-https -y \
  && apt-get update && apt-get install -y dh-python g++ make yarn

# For Capybara
#RUN apt-get install -y -qq libqt4-dev libqtwebkit-dev

RUN mkdir -p /app
WORKDIR /app
COPY . .
# Add app files into docker image

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
RUN gem update --system ; gem install bundler:2.3.7; bundle config build.nokogiri --use-system-libraries
RUN bundle check || bundle install --without production
RUN yarn install

