#!/bin/bash

# Do not fiddle with my running services when boostrapping.
# Exsepcially annoying in case of virtualbox updates...
export YAST_IS_RUNNING="instsys"

function zypper_with_opts {
  zypper --quiet --non-interactive $@
}

function vecho {
  echo -e "$@..."
}

vecho "Add repositories for sphinx search engine"
zypper_with_opts addrepo -f 'http://download.opensuse.org/repositories/server:/search/openSUSE_Leap_42.3/server:search.repo'

vecho "Add repositories for ruby"
zypper_with_opts addrepo -f 'http://download.opensuse.org/repositories/devel:/languages:/ruby/openSUSE_Leap_42.3/devel:languages:ruby.repo'

vecho "Refresh repositories"
zypper_with_opts --gpg-auto-import-keys refresh

vecho "Update the system from repositories"
zypper_with_opts dup

vecho "Install required packages"
zypper_with_opts install ruby2.2 ruby2.2-devel mariadb sphinx libxml2-devel libxslt-devel sqlite3-devel nodejs gcc-c++ ImageMagick libmysqlclient-devel phantomjs

vecho "Disable versioned gem binary names"
echo 'install: --no-format-executable' >> /etc/gemrc

# FIXME: This is pinned because of https://github.com/bundler/bundler/issues/6535
vecho "Install bundler"
gem.ruby2.2 install bundler -v 1.16.1

vecho "Setup ruby binaries"
ln -sf /usr/bin/ruby.ruby2.2 /usr/local/bin/ruby
for bin in rake rdoc ri; do
   /usr/sbin/update-alternatives --set $bin /usr/bin/$bin.ruby.ruby2.2
done
update-alternatives --remove rspec /usr/bin/rspec.ruby2.1-3.4.4
update-alternatives --remove pry /usr/bin/pry.ruby2.1-0.10.3

vecho "Enable MySQL service"
chkconfig mysql on
service mysql start
mysqladmin -u root password 'hackweek'

vecho "Download english morphology dictionary"
wget -q 'http://sphinxsearch.com/files/dicts/en.pak' -O /vagrant/en.pak

vecho "Setting up the Rails environment for 'hackweek'"
su - vagrant -c 'cd /vagrant && bundle && rake dev:bootstrap'

vecho "Your hackweek development box has been set up."
vecho "Start the app with\n\t\t vagrant exec foreman start"
vecho "Happy Hacking!\n\n"
