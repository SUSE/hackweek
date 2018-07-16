FROM opensuse/leap:15.0
ARG CONTAINER_USERID

# Add needed repos
RUN echo 'solver.allowVendorChange = true' >> /etc/zypp/zypp.conf; \
    zypper ar -f https://download.opensuse.org/repositories/server:/search/openSUSE_Leap_15.0/server:search.repo; \
    zypper ar -f https://download.opensuse.org/repositories/devel:/tools/openSUSE_Leap_15.0/devel:tools.repo; \
    zypper --gpg-auto-import-keys refresh


# Install requirements
RUN zypper -n install --no-recommends --replacefiles \
  curl vim vim-data psmisc timezone ack glibc-locale sudo hostname \
  sphinx libxml2-devel libxslt-devel sqlite3-devel nodejs8 gcc-c++ \
  ImageMagick libmysqld-devel phantomjs ruby-devel make git-core;

# Add our user
RUN useradd -m frontend

# Configure our user
RUN usermod -u $CONTAINER_USERID frontend

# Setup sudo
RUN echo 'frontend ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Disable versioned gem binary names
RUN echo 'install: --no-format-executable' >> /etc/gemrc

# Install bundler
# FIXME: This is pinned because of https://github.com/bundler/bundler/issues/6535
RUN gem install bundler -v 1.16.1; gem install foreman

# We copy the Gemfiles into this intermediate build stage so it's checksum
# changes and all the subsequent stages (a.k.a. the bundle install call below)
# have to be rebuild. Otherwise, after the first build of this image,
# docker would use it's cache for this and the following stages.
ADD Gemfile /hackweek/Gemfile
ADD Gemfile.lock /hackweek/Gemfile.lock
RUN chown -R frontend /hackweek

WORKDIR /hackweek
USER frontend

# Install gems we use outside of the bundle
RUN sudo gem install foreman

# Refresh our bundle
RUN export NOKOGIRI_USE_SYSTEM_LIBRARIES=1; bundle install --jobs=3 --retry=3 || bundle install --jobs=3 --retry=3

# Run our command
CMD ["/bin/bash", "-l"]



