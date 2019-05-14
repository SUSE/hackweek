[![Build Status](https://travis-ci.org/SUSE/hackweek.png?branch=master)](https://travis-ci.org/SUSE/hackweek)
[![Coverage Status](https://img.shields.io/coveralls/SUSE/hackweek.svg)](https://coveralls.io/r/SUSE/hackweek)
[![Code Climate](https://codeclimate.com/github/SUSE/hackweek.png)](https://codeclimate.com/github/SUSE/hackweek)

HackWeek
--------
A tool to nurture hack ideas into projects and then collaborate on them. It's used
during [SUSEs hackweek](http://hackweek.suse.com), a week where SUSE engineers can
experiment without limits and get their opportunity to innovate, collaborate across teams,
and learn.

<img src="https://raw.github.com/SUSE/hackweek/master/design/screenshot.png">

## Features
* Admins can add hackweeks
* Users create ideas for a hackweek
* Users can like and comment on ideas
* Users can join ideas turning them into projects
* Users can supplement projects with files, links, agenda items and "needs"
* Users can supplement themselves with "haves"
* Ideas/Projects "needs" are matched to Users "haves"
* Admins can rate project results

## Requirements
Sphinx (searchd) must be installed. No need to configure and launch it
separately, everything will be taken care of with `rake ts:regenerate`.

## Hack it
As our project involves somewhat complicated setup (MySQL and Shpinx search)
for a development environment, we have created docker and vagrant files to
get you up and running.

### Docker

1. Since we mount the hackweek repository into our container we need to map
   your local user id to the one of the container user. To do that copy the
   `docker-compose.override.yml` file and enter your user id (`id -u`) as
   `CONTAINER_USERID`.
   ```bash
   cp docker-compose.override.yml.example docker-compose.override.yml
   vi docker-compose.override.yml
   ```
1. Set up the development environment:
   ```bash
   docker-compose run --rm hackweek bundle exec rake dev:bootstrap
   ```
1. Start the development environment:
   ```bash
   docker-compose up --build
   ```

### Vagrant

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [vagrant](https://www.vagrantup.com)
1. Install vagrant-exec plugin:
   ```shell
   vagrant plugin install vagrant-exec
   ```
1. Start our openSUSE 42.3 based virtual machine with vagrant:
   ```shell
   vagrant up
   ```
1. Launch the application:
   ```shell
   vagrant exec foreman start
   ```
1. Access the appliaction as usual:
   ```shell
   xdg-open http://localhost:3000
   ```
1. [Start hacking](http://railsforzombies.org/)
1. [Test your changes](https://www.relishapp.com/rspec/rspec-core/docs)
   ```shell
   vagrant exec rspec
   ```
1. [Send pull request](https://help.github.com/articles/using-pull-requests)
1. $UCCE$$

Remote connection to the virtual machine is available with `vagrant ssh`. You
can run single-shot remote commands like `vagrant exec rake db:migrate`. If you
are done hacking you can stop the virtual machine with `vagrant halt` and
remove all traces of it with `vagrant destroy`.

## Resources
* Design mockups of the rails app are in the design directory.
* The project list for HackWeek9 is in the [Wiki](http://github.com/SUSE/hackweek/wiki).
* There are some tools in the tool directory.
* Data of past hackweeks is in the archive directory.
* The source of the [old webpage](http://suse.github.io/hackweek/) is in the gh-pages branch.
