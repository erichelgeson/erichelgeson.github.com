---
layout: post
title: Ditch Install Scripts, give me Chef.
excerpt: It's time to end the install.sh and move towards chef or puppet.
category: blog
---

Project maintainers usually have an install wiki, or document, or book on how to install their software package. Everyone who wants to try it runs into the same issues and same decisions while installing. Oh it's ruby1.8 on Ubuntu 12.10, well then compile it yourself, or worse yet there is a install.sh that works only on one distro, only one time, if you answer all the questions right... So don't screw it up!

This is many times a huge barrier to evaluating new software. 

What I'm proposing is software projects start to make chef and puppet recipes first class citizens of their project repository instead of waiting for opscode, puppet, or the community to build them for their project. 

Currently there are many recipes available from the community but these are usually lagging behind releases. In the case opscode and tomcat7 (released in 2010), a release can be held up by copyright issues of a community patch.

Cutting down the barrier to entry and allowing people to try your software project, on their own OS/Cloud/Infrastructure almost instantly in a testable, repeatable, maintainable  recipe cuts down that barrier to next to nothing.
