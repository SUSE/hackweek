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
* Users ceate ideas for a hackweek
* Users can like and comment on ideas
* Users can join ideas turning them into projects
* Users can supplement projects with files, links, agenda items and "needs"
* Users can supplement themselves with "haves"
* Ideas/Projects "needs" are matched to Users "haves"
* Admins can rate project results

## Hack it
* [Fork this repository](https://help.github.com/articles/fork-a-repo)
* Configure the rails app
```shell
cp config/database.yml.example config/database.yml
cp config/application.yml.example config/application.yml
cp config/secrets.yml.example config/secrets.yml
```
* Install the ruby gem bundle
```shell
bundle install
```
* Create the database
```shell
rake db:setup
```
* Run the search server
```shell
rake sunspot:solr:start
```
* Run the rails server
```shell
rails server
```
* Open http://0.0.0.0:3000 in your browser
* [Start hacking](http://railsforzombies.org/)
* [Test your changes](https://www.relishapp.com/rspec/rspec-core/docs)
```shell
rspec spec
```
* [Send pull requesst](https://help.github.com/articles/using-pull-requests)

## Resources
* Design mockups of the rails app are in the design directory.
* The project list for HackWeek9 is in the [Wiki](http://github.com/SUSE/hackweek/wiki).
* There are some tools in the tool directory.
* Data of past hackweeks is in the archive directory.
* The source of the [old webpage](http://suse.github.io/hackweek/) is in the gh-pages branch.

## Requirements
Because of sunspot solr, it requires java. We have installed java-1_7_0-ibm.
