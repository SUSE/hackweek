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

# Setup environment for our user
RUN ln -sf /hackweek/tmp/.bash_history /home/hackweek/.bash_history; \
    ln -sf /hackweek/tmp/.irb_history /home/hackweek/.irb_history;

# Setup Ruby 3.4 environment for our user
RUN ln -sf /usr/bin/ruby.ruby3.4 /home/hackweek/bin/ruby; \
    ln -sf /usr/bin/gem.ruby3.4 /home/hackweek/bin/gem; \
    ln -sf /usr/bin/bundle.ruby3.4 /home/hackweek/bin/bundle; \
    ln -sf /usr/bin/rake.ruby3.4 /home/hackweek/bin/rake;

# Install our process manager
RUN /home/hackweek/bin/gem install foreman; \
    ln -sf /home/hackweek/.local/share/gem/ruby/3.4.0/bin/foreman /home/hackweek/bin/foreman;

# Run our command
CMD ["/home/hackweek/bin/foreman", "start", "-p", "3000"]
