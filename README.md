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

## Creating a New Rails Project with vagrant-box

Creating a new project from scratch with vagrant-box is rather simple, even if you don't have Rails (or even Ruby) installed locally.

	$ git clone https://github.com/jarkelen/vagrant-box <my_project>
	$ cd <my_project>
	$ vagrant up
	
Once Vagrant has finished setting up the new development box, you can remote into the box and begin setting up a new Rails project.

	$ vagrant ssh
	
If everything worked, you'll now be connected to your development box.  Now you can install Rails and create a new rails project.

	takeout$ cd /vagrant
	takeout$ gem install rails 
	takeout$ rails new .
	
Your new Rails project is now created *on your local machine in the folder you created for your project* (`<my_project>`).  You can add it (and vagrant-box) to source control and begin developing.  Keep in mind that the `.vagrant/` folder doesn't belong in source control. Take whatever steps are necessary to make sure it doesn't end up there.

You can start the Rails development server directly inside the vagrant-box development box and edit it directly on your host machine.  

	takeout$ rails server
	
Since Vagrant is nice enough to do some port forwarding for us, you can also view the Rails app in your host's browser at http://localhost:3000.

When you're done developing, you can exit the development box and suspend the VM.

	$ vagrant suspend

When you're ready to start coding again, Vagrant can help you there as well.

	$ vagrant up

For more information on using Vagrant, be sure to check out the [Vagrant website](http://www.vagrantup.com).

## Adding vagrant-box to an Existing Rails Project

If you've already got an existing Rails project, adding vagrant-boxcan still be benenficial (especially if you like keeping your system clean).  It's easy: just copy the project files (`puppet/` folder and `Vagrantfile` file) to your Rails project folder.  Booting up the development box is simple.

	$ cd <my_project>
	$ vagrant up
	
Once Vagrant has finished setting up the box, remote into it, install your project's gem bundle, and start up the Rails development server.

	$ vagrant ssh
	takeout$ cd /vagrant
	takeout$ bundle install
	takeout$ rails server
	
You can now edit your project locally, and view it in your local web browser at http://localhost:3000.  Again, remember that the `.vagrant/` folder shouldn't go into source control.  
