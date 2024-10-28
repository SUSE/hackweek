FROM registry.opensuse.org/opensuse/infrastructure/dale/containers/hackweek/base:latest
ARG CONTAINER_USERID=1000

# Configure our user
RUN usermod -u $CONTAINER_USERID hackweek

# We copy the Gemfiles into this intermediate build stage so it's checksum
# changes and all the subsequent stages (a.k.a. the bundle install call below)
# have to be rebuild. Otherwise, after the first build of this image,
# docker would use it's cache for this and the following stages.
ADD Gemfile /hackweek/Gemfile
ADD Gemfile.lock /hackweek/Gemfile.lock
RUN chown -R hackweek /hackweek

WORKDIR /hackweek
USER hackweek

# Install our bundle & process manager
RUN bundle install --jobs=3 --retry=3; \
    gem install foreman

# Run our command
CMD ["foreman", "start", "-f", "Procfile"]
