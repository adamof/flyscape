# Rails Take-Out - Rails Development Anywhere



## Introduction

Developing Rails applications is fun.  Getting a Rails development environment up and running isn't.

Take-Out automates the setup of a development environment for working on Ruby on Rails applications.  This project is based on [rails-dev-box](https://github.com/rails/rails-dev-box) with some tweaks to make Rails app development easier.



## Requirements

* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](http://vagrantup.com)



## What's In The Box

* Git
* RVM
* Ruby 2.0.0 (binary RVM install)
* Bundler
* SQLite3
* Postgres (username `rails`, password `rails`)
* System dependencies for nokogiri, sqlite3 and pg
* Default database users for Rails database configuration
* Node.js for the asset pipeline
* Memcached



## Creating a New Rails Project with Take-Out

Creating a new project from scratch with Take-Out is rather simple, even if you don't have Rails (or even Ruby) installed locally.

	$ git clone https://github.com/MatthewMcMillion/Rails-Box.git <my_project>
	$ cd <my_project>
	$ vagrant up
	
Sit back and relax; Vagrant's doing all the work.  Depending on your connection speed and whether or not you've used Take-Out before, this can take anywhere from a few minutes to an hour.  Don't' worry, once Take-Out has downloaded the Vagrant box, this will only take a minute or two in the future.  Feel free to  `rm -rf .git` inside the newly created project folder to get rid of Take-Out's history and start a repo of your own.

Once Vagrant has finished setting up the new development box, you can remote into the box and begin setting up a new Rails project.

	$ vagrant ssh
	
If everything worked, you'll now be connected to your development box.  Now you can install Rails and create a new rails project.

	takeout$ cd /vagrant
	takeout$ gem install rails 
	takeout$ rails new .
	
Your new Rails project is now created *on your local machine in the folder you created for your project* (`<my_project>`).  You can add it (and Take-Out) to source control and begin developing.  Keep in mind that the `.vagrant/` folder doesn't belong in source control. Take whatever steps are necessary to make sure it doesn't end up there.

You can start the Rails development server directly inside the Take-Out development box and edit it directly on your host machine.  

	takeout$ rails server
	
Since Vagrant is nice enough to do some port forwarding for us, you can also view the Rails app in your host's browser at http://localhost:3000.

When you're done developing, you can exit the development box and suspend the VM.

	takeout$ exit
	$ vagrant suspend

When you're ready to start coding again, Vagrant can help you there as well.

	$ vagrant up

For more information on using Vagrant, be sure to check out the [Vagrant website](http://www.vagrantup.com).



## Adding Take-Out to an Existing Rails Project

If you've already got an existing Rails project, adding Take-Out can still be benenficial (especially if you like keeping your system clean).  It's easy: just copy the project files (`puppet/` folder and `Vagrantfile` file) to your Rails project folder.  Booting up the development box is simple.

	$ cd <my_project>
	$ vagrant up
	
Once Vagrant has finished setting up the box, remote into it, install your project's gem bundle, and start up the Rails development server.

	$ vagrant ssh
	takeout$ cd /vagrant
	takeout$ bundle install
	takeout$ rails server
	
You can now edit your project locally, and view it in your local web browser at http://localhost:3000.  Again, remember that the `.vagrant/` folder shouldn't go into source control.  This will make collaborators using Take-Out very unhappy.



## Licensing

Rails Take-Out is licensed under GPL v3.  Some Puppet recipes are licensed under GPL v3 and Apache 2.0.