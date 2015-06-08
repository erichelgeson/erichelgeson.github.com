---
layout: post
title: Building chef from source to change Prefix
excerpt: Installing and running chef outside of /opt/
category: blog
---
There may be times when you want chef to be located somewhere besides `/opt/chef`. Currently you can't just use `rpm --prefix=/data/myapp` to move it to a different location due to compile time settings, so lets compile chef using omnibus to store it under `/data/myapp/chef`.

First we need three repos that comprise omnibus for chef -

```bash
$ git clone git@github.com:chef/opscode-omnibus.git
$ git clone git@github.com:chef/omnibus-software.git
$ git clone git@github.com:chef/omnibus-chef.git
```

Then lets checkout the version of `omnibus-chef` that is closest without going over the version of chef we'd like to install. `omnibus-chef` and `chef` versions do not match 1-1.

```bash
$ cd omnibus-chef
# git tag list # to list tags
# git checkout tags/<version here>
$ git checkout tags/chef-12.2.0
```


I'm building RPMs for centos. omnibus will build the package for whatever platform it is run on.

Lets Edit a few files for our usecase -

`.kitchen.yml`

```
# Change the box to something that can be downloaded from vagrant cloud
# in this case I replaced centos-6.5 with chef/centos-6.5
  - name: chef/centos-6.5
....
# Change the install_dir to the location you want the RPM to be installed
attributes:
  omnibus:
    <<: *attribute_defaults
        install_dir: /data/myapp/chef
```

We need to override the `default_root` in the `omnibus-chef` project to set the new root. Its originally set in the omnibus package, but we'll just hax it here quick:

`config/projects/chef.rb`

```ruby
default_root = "/data/myapp"
```

Lastly pin the version of chef you'd like installed

`config/projects/chef.rb` [0]

```ruby
override :chef, version: "12.3.0"
override :ohai, version: "8.3.0"
```

Optionally edit, or remove, the `package-scripts/chef/postinst` script. In my case I wanted it to not touch other parts of the file system so I commented it out. Most cases you'd just change this line -

```
INSTALLER_DIR=/data/myapp/chef
```

```bash
$ kitchen converge chef-chef-centos-65
$ kitchen login chef-chef-centos-65
# Setup Env (dont worry about the error)
$ source ./load-omnibus-toolchain.sh
$ cd omnibus-chef
$ bundle install --without development

$ bundle exec omnibus build chef

# Clean out dir if you have an issue or change versions you're building
$ bundle exec omnibus clean chef
```

You then should have a package under the `pkg/` folder ready to test out!

[0] - Example pin of chef version - <https://github.com/chef/omnibus-chef/commit/0afd9bbe9df486ccebf5908b4f17a1b013860abc>
