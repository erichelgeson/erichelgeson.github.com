---
layout: post
title: Upgrading to Grails 3
excerpt: Notes on upgrading to Grails 3
category: blog
---

We set out to upgrade [Sproutary.com](https://sproutary.com/?ref=blog) - online software to manage daycares & pre-schools - from a Grails 2.5.x project to Grails 3. When we started building Sproutary we knew we would want to upgrade to Grails 3. We kept our dependencies on plugins to a minimum to ensure upgrading would be easier and not depend on an abandoned plugin.

The approach we took was to start a `grails3` branch early and attempt an upgrade, knowing there would be bugs and issues we could report back to Grails. We would deploy it when it's ready. There was no rush to upgrade as Grails 2.5.x is still being released with bug fixes.

This post is me going over the past 7 months of the `grails3` branch and giving you my perspective on the upgrade. Hopefully this insight will help you when trying to upgrade.

#### TLDR

* Time to upgrade is now
* Most of the plugins you need have been upgraded
* Get rid of plugins you don't need or replace with spring-boot alternatives
* Hibernate Sessions are stricter
* Lurk & ask questions in [Grails Slack](http://slack-signup.grails.org/)

## The Beginning

We started out on Grails 3.0.4.

About that time most of the plugins we depended on were being released -

* Spring Security Core - It is fairly simple to use Spring Boot and Spring Security directly, but that was not code I wanted to build or maintain myself.
* Quartz - Easy job scheduling, though this plugin gave me the biggest issue preventing me from upgrading, more on that later.
* Mail
* Database Migrations
* Postgres Extensions
* Build-Test-Data
* Raven exception reporting
* Memcached Session Manager - Replaced with `spring-session`
* Google Analytics - I removed this dependency and just added my tag as a GSP include.

Thats it. Like I said I was keeping plugins thin as to ease the upgrade.

## First hurdles

### Intermittent Filters

My first maddening issue had to do with Filters. Yes they're deprecated but still work. The issue I ran into was I had the filter in the wrong directory, which would normally be fine because it shouldn't work right? Well oddly it did work, sometimes! After many hours and debugging I found out Spring Loaded would pick it up and add it in, so every time I looked at it it would work, and if I didn't it wouldn't! Of course hindsight is 20/20 but I wasted a fair amount of time on this (and eventually moved the logic to an Interceptor)

<https://github.com/grails/grails-core/issues/9221>

### Sessions

At Sproutary we do blue/green deploys and we don't want our users to be logged out when we push new code. This means we need to keep sessions out of the JVM and in something else. For Grails 2 I updated the [standalone-memcached plugin to work with tomcat 8](https://github.com/erichelgeson/grails-standalone-tomcat8-memcached).

In Grails 3 we can use spring-boot dependencies, and I noticed the awesome spring-session project. I added it to my `grails3` branch and it worked! Well, almost. After some debugging we figured out there was an ordering issue between Grails and Boot which was fixed in boot 1.3/Grails 3.1.

<https://github.com/spring-projects/spring-session/issues/245>

### application.yml vs. application.groovy

Grails lets you use both an `application.yml` file and an `application.groovy` file. That's great, but early on there were issues related to merging of the configuration between the two. My advice here is to just pick one and stick with it. My choice was .groovy so we can be a bit more dynamic in our configuration.

### GSP

We ran into GSP rendering and resolution issues with layouts and includes with 3.0.x. These issues have been resolved.

## Plugins

### Spring Security Core

This was fairly straight-forward after [reading the docs thoroughly](https://grails-plugins.github.io/grails-spring-security-core/v3/index.html#newInV3). The basics are that URL and parameter names changed.

### Database Migrations

Only thing to note here is I was unable to go back to the Grails 2 branch after the `migrations` on Grails 3 ran (even with no changes). This meant that I would be unable to roll back to Grails 2 without doing a restore of the database.

### Quartz

As mentioned earlier this plugin gave me the biggest delay, but the fix was trivial.

I use a database store to keep my jobs in sync between JVMs and restarts. I would continually get errors when Quartz was starting up even though I was using the same configuration as Grails 2. I kept coming back to this over months unable to figure out what was going wrong.

Ultimately the issue was with the way the `props` were being read in in `application.yml`. I moved everything over to `application.groovy` and it worked.

The second issue was when a job was being resumed after a restart it would not have a hibernate session and would fail. To get around this I moved all my logic from the `execute()` portion of the job to a `Transactional` service.

<https://github.com/grails-plugins/grails-quartz/issues/62>

The last issue was the quartz jobs were not fired on the Grails 3 JVM. I believe it was due to me changing the `scheduler.instanceName` name. I was able to reschedule the jobs quickly as they are all defined programmatically.

## Hibernate & GORM

Hibernate sessions appear to be stricter in Grails 3 than they were in 2. This is probably a good thing as I restructured my app to move that logic from controllers to services which made things much more testable.

Grails 3.1.x comes with GORM 5, a complete re-write of GORM which is still working out a few issues, but for the most part, is a drop in replacement. Note though IntelliJ does not support GORM5 yet.

As mentioned in the Quartz section I moved all my logic to a `Transactional` service to avoid no session found issues.

I use the association id (eg: `foo.barId`) in many locations to avoid a second database query if all I need is the id. After upgrading to 3.1.4 I noticed this stopped working. (but will be fixed in 3.1.5)

<https://github.com/grails/grails-data-mapping/issues/686>

The last issue I ran into was when I deployed my app to a production like environment my controllers would start throwing `StaleObject` exceptions all over the place, though everything was working. I haven't found the root cause of this yet but was able to work around this by adding `@Transactional(readonly=true)` to all of my controllers that were throwing this exception.

## Deployment

We use centos and chef to do the infrastructure configuration. This was easy to add in redis (for sessions) and slightly change the JVM options for Grails 3.

We ran Grails 2 as a standalone jar and with Grails 3 that is the default so just a few tweaks to the `systemd` service definition.

We were able to use the same blue/green deploy when deploying the Grails 3 branch and there was 0 downtime.

### Day of Deployment

There were a few minor issues I ran into after deployment. Nothing specific to Grails but may help others if they are in similar situations.

We keep sensitive information outside of `git` and read it in at startup time. The JVM arg should have started with `file:` which was missed. This affected redirects for a short time as the app didn't know the `grails.serverURL` and Stripe/email, though no transactions or emails were affected.

We added websocket support for a few features in this release. We use CloudFlare as a CDN which we don't have in our non-production environments. CloudFlare doesn't support websockets on the free tier. We moved over to Lets Encrypt for SSL and removed CloudFlare for now.

## Summary

Grails 3.1.4 is the first version of Grails 3 which everything started working for us. There are a few minor work arounds in place for Transactions but they should be resolved soon.

Get rid of plugins that provide little value and write it yourself.

There are many spring-boot dependencies that can replace plugins completely, for example spring-session.

### Good

Deployments (JVM startup & warm up) time is 2x faster than Grails 2.

Tests run 2x faster than they did in Grails 2.

### Bad

IntelliJ support was very poor during the last few months with gradle issues, code navigation issues, and no GORM 5 support. Gradle issues seem to be resolved in 2016.1 but GORM 5 and code navigation issues still are there (but are marked to be fixed in 2016.2).

## Notes

When rebasing a branch for 7 months you should enable `git rerere` (reuse recorded resolution) to make rebasing painless - `git config --global rerere.enabled true` <https://git-scm.com/blog/2010/03/08/rerere.html>
