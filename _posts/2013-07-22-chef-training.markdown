---
layout: post
title: Chef Testing and Training
excerpt: Notes on testing Opscode Chef from training
category: blog
---
Ive been using chef now for about 6 months now on and off, self taught, professionally and personally, but was lucky enough to take a 3 day chef fundamentals training course from a local chef guru [@tomduffield](http://twitter.com/tomduffield). It was a great level set for many concepts Ive seen in cookbooks but didnt see the patterns till now. Also I received a certificate of awesome that Ill be hanging up at my desk to remind me how awesome I am :)

One thing that always peaks my interest is testing. Infra has always been that one thing that you just hope will work when you get the config right, or the network settings right, but you never know until you actually make the change. Virtualization/Cloud with APIs, along with the emerging set of tools for chef automation and testing are changing the way we create, test and deploy applications.

Tom drew a nice layout of the current state of Chef testing tools and approaches. Here are my notes from the conversation:

---

#### 3 types/stages of chef testing

##### Pre Converge 
Static code analysis

* git precommit hook with:
* [knife cookbook test](http://docs.opscode.com/knife_cookbook.html#test)
* [foodcritic](http://acrmp.github.io/foodcritic/)
* peer code reviews \(Pull Requests/Gerrit\)

##### Pseudo Converge
What it thinks its going to do before it happens

* [Chefspec](http://acrmp.github.io/chefspec/) uses rspec, [monkey patches](http://en.wikipedia.org/wiki/Monkey_patch) chef.

##### Post Converge
Actually build environments and do asserts on the infrastructure
* [vagrant](http://vagrantup.com/) with human eyes looking at the output
* [minitest chef\_handler](https://github.com/calavera/minitest-chef-handler)
* [cucumber\_chef](https://github.com/Atalanta/cucumber-chef)
* [test\_kitchen](https://github.com/opscode/test-kitchen) with vagrant for testing multiple OSs at the same time

---

My take aways, and possible future blog posts:
* Other cool things Ill be looking at is using [chef-zero](https://github.com/jkeiser/chef-zero) to play with instead of chef-solo to test my searches locally.
* Setup a Continuous Integration/Continuous Delivery environment with Jenkins

Other tips or tools on chef testing? Fork this post and contribute below!
