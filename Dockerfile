FROM ruby:2.4.2
RUN apt-get update -qq && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get update && apt-get install -y nodejs build-essential && \
    apt install -y curl apt-transport-https wget && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn && \
    echo deb http://www.deb-multimedia.org jessie main non-free >> /etc/apt/sources.list && \
    apt-get update && apt-get install -y ffmpeg

ENV APP_ROOT /app
WORKDIR $APP_ROOT

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
#CMD ["rails", "server", "-b", "0.0.0.0"]
CMD ["bash"]