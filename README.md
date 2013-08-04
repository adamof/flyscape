# vagrant-box - boxed Rails development

## Introduction

Developing Rails applications is fun.  Getting a Rails development environment up and running isn't.

vagrant-box automates the setup of a development environment for working on Ruby on Rails applications.  This project is based on [Rails-Take-Out](https://github.com/MatthewMcMillion/Rails-Take-Out) with some tweaks to adjust to my personal setup preferences.

## Requirements

* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](http://vagrantup.com)

## What's In The Box

* Git
* RVM
* Ruby 2.0.0 (binary RVM install)
* Bundler
* Postgres (username `rails`, password `rails`)
* System dependencies for nokogiri, sqlite3 and pg
* Default database users for Rails database configuration
* Node.js for the asset pipeline
* Memcached

## Setup
```
local: git clone
local: cd flyscape
local: vagrant up
local: vagrant ssh
vagrant: cd /vagrant
vagrant: bundle install
vagrant: rake db:create
vagrant: rails server
```
Now go to localhost:3000 on your local mashine and see the application working!
