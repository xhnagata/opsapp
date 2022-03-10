FROM ruby:3.0.3-alpine
RUN apk add build-base freetds-dev && \
    mkdir -p /opsapp && \
    gem update --system && gem install bundler --no-document

WORKDIR /opsapp
COPY ["Gemfile", "Gemfile.lock", "./"]
RUN bundle install -j2 && \
    bundle clean --force
COPY ./ ./
CMD ./startup.sh
