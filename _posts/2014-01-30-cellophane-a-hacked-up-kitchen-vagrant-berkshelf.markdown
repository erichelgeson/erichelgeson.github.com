---
layout: post
title: Cellophane A hacked up kitchen vagrant berkshelf
excerpt: Cellophane A hacked up kitchen vagrant berkshelf
category: blog
---

Since [vagrant-berkshelf is now deprecated](https://sethvargo.com/the-future-of-vagrant-berkshelf/) and [test-kitchen](http://kitchen.ci/) is the way forward I've been thinking how I can still share my boxes with my Java developers who do not have (or want) ruby on their machine, but still want a disposable prod like tomcat/cassandra/zookeeper VM's on their machines using Berkshelf and Vagrant.

Vagrant has an omnibus version of ruby... so why not use a kitchen wrapper (inspired by [gralsw](http://mrhaki.blogspot.com/2013/03/grails-goodness-using-wrapper-for.html)) + bundler + vagrant's embedded ruby to have no external dependencies?

**Caviot: I know this is a horrible way to do it, I just hacked it together this morning.**

Since the vagrant script sets the correct environment I used that as a template.

I copied /usr/bin/vagrant to my box location and named it ./kitchenw and added this to the bottom, commenting out the vagrant execute call:

{% highlight bash %}
... top 93 lines from /usr/bin/vagrant ...
# Call the actual Vagrant bin with our arguments
#"${RUBY_EXECUTABLE}" "${VAGRANT_EXECUTABLE}" "$@"
#########################
# Start kitchen wrapper #
#########################

# Create gemfile.
cat > ".kitchen/kitchenw.gemfile" <<EOF
source 'https://rubygems.org'
gem 'test-kitchen'
gem 'kitchen-vagrant'
gem 'berkshelf'
gem 'pry'
EOF
# On first run isntall the vagrant bundler plugin
if [ `"${RUBY_EXECUTABLE}" "${VAGRANT_EXECUTABLE}" plugin list | grep bundler |wc -l` == "0" ]; then
  echo "Installing bundler for the first time..."
  "${RUBY_EXECUTABLE}" "${VAGRANT_EXECUTABLE}" plugin install bundler
fi

# Install the bundle
if [ ! -f ".kitchen/kitchenw.gemfile.lock" ]; then
  BUNDLE_GEMFILE=.kitchen/kitchenw.gemfile "${RUBY_EXECUTABLE}" "${EMBEDDED_DIR}"/bin/bundle install --path .kitchen/bundler --gemfile=.kitchen/kitchenw.gemfile
fi

# Run kitchen!
BUNDLE_GEMFILE=.kitchen/kitchenw.gemfile "${EMBEDDED_DIR}/bin/bundle" exec kitchen "$@"
{% endhighlight %}

Now I can just do:

{% highlight bash %}
./kitchenw converge # vs vagrant up
./kitchenw login .  # vs vagrant ssh
./kitchenw destroy  # vs vagrant destroy
{% endhighlight %}

Next steps? Make this a real thing? a .bat for Windows? Burn it with fire?

The right solution may be to have a 'vagrant-kitchen' cookbook that uses the right gems in the embedded ruby for using the kitchen, if they are bundled separately from vagrants gems. I don't know enough about how that is handled.

The use case and value of distributing your infrastructure to developers who don't care about ruby, and do care about servers is still valid.

