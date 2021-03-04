[![Build Status](https://travis-ci.org/SUSE/hackweek.png?branch=master)](https://travis-ci.org/SUSE/hackweek)
[![Coverage Status](https://img.shields.io/coveralls/SUSE/hackweek.svg)](https://coveralls.io/r/SUSE/hackweek)
[![Code Climate](https://codeclimate.com/github/SUSE/hackweek.png)](https://codeclimate.com/github/SUSE/hackweek)

HackWeek
--------
A tool to nurture hack ideas into projects and then collaborate on them. It's used
during [SUSE's hackweek](http://hackweek.suse.com), a week where SUSE engineers can
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
As our project involves somewhat complicated setup (MySQL and Sphinx search)
for a development environment, we have created a Docker Compose setup to
get you up and running.

1. Since we mount the hackweek repository into our container, we need to map
   your local user id to the one of the container user. Otherwise files created
   inside the container might not be writeable. If your user id (`id -u`) is
   something else than `1000`, then copy the `docker-compose.override.yml` file
   and set your user id number in the variable `CONTAINER_USERID`.
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
1. Access the application as usual:
   ```shell
   xdg-open http://0.0.0.0:3000
   ```
1. [Start hacking](http://railsforzombies.org/)
1. [Test your changes](https://www.relishapp.com/rspec/rspec-core/docs)
   ```shell
   docker-compose exec hackweek rspec
   ```
1. [Send pull request](https://help.github.com/articles/using-pull-requests)
1. $UCCE$$

"Remote" connection to the container is available with `docker-compose exec hackweek /bin/bash`. You
can run single-shot remote commands like `docker-compose exec hackweek rake db:migrate`.

## Resources
* Design mockups of the Rails app are in the design directory.
* The project list for HackWeek9 is in the [Wiki](http://github.com/SUSE/hackweek/wiki).
* There are some tools in the tool directory.
* Data of past hackweeks is in the archive directory.
* The source of the [old webpage](http://suse.github.io/hackweek/) is in the gh-pages branch.
