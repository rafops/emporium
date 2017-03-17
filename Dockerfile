FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y nodejs
RUN mkdir /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
WORKDIR /app
ENV DATABASE_USERNAME postgres
ENV DATABASE_HOST db
ENV REDIS_URL redis://redis:6379/1
RUN bundle install
CMD ["bundle exec rails c"]
