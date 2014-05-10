---
layout: post
title: Automating your Automation - Federated Jenkins with Chef
excerpt: Automating your Automation - Federated Jenkins with Chef
category: blog
---
Have you ever had someone update a plugin or add an executor to your Jenkins 
install and all your jobs started failing? I know I have.

The future of Jenkins is a federated master model. No more single master
enterprise installs of Jenkins. Jenkins is the orchestrator for your 
CI/CD pipelines, if it's down you won't be pushing any code.

The alternative approach is to allow teams to build a Jenkins master easily,
reliably, and test their plugins and dependencies before applying them in
production. 

A few tools have recently made this approach possible:

* Jenkins cookbook. Not only does it install and do the initial configure, it
manages Jenkins for the long haul, including plugins, authentication, and all
configuration.

* Jenkins Job DSL. You're still creating jobs by hand? How quaint. There is no way to scale, audit, or track changes.

* The Job DSL allows you to write groovy code to describe your jobs.
That means
 - Jobs are now in version control
 - You can peer review job changes
 - You can write tests for jobs(!)
 - You can make and extend classes of jobs
 - Infrastructure APIs - If you are going to give everyone their own Jenkins
install, they need a way to get machines quickly via OpenStack or a Cloud
provider.

* Even Cloudbees is seeing this trend with their release of Jenkins Operations Center <http://www.cloudbees.com/joc>

I set out to create and document a wrapper Jenkins cookbook that would utilize
these tools and build our pipeline quickly and automatically each time.

## Goals:

* Shield the team from any centralized Jenkins Master downtime.

* Allow developers to have a Jenkins install on their local machine to test and build Jobs.

* Jobs are only created via the Jenkins DSL.

* Plugins are managed via the chef recipe and can be reviewed/tested before being deployed to production Jenkins.

* Security model and distributing the cookbook (with it's passwords/secrets
embedded). Utilize the Github OAuth API to login to Jenkins. This allows any
developer to create an API secret/key and test on their machine. 
  
## Gaps:

* I couldn't find a good way to manage views or pipelines via the API. We use the folder view and currently have to create it manually.

* Plugins always install 'latest' by default and do not pull in dependencies. 

* Managing Jenkins slaves.

Here's a high level overview of the cookbook though I've documented in the
cookbook the whats and whys. 
This will work OOB but should be a starting point for your own and includes
documentation about gotcha's. 

## [The Wrapper Cookbook](https://github.com/erichelgeson/jenkins-chef-dsl)

The goal of this project is to be a reference wrapper cookbook for others to
jumpstart their Jenkins infrastructure. I would encourage others to fork this
and add features and documentation where I have gaps. I will continue to add to
this post and update Cookbook.

I've commented the source but  here are the highlights:

* [jenkins-chef-dsl::default](https://github.com/erichelgeson/jenkins-chef-dsl/blob/master/recipes/default.rb) 
 - This installs everything needed for Jenkins and chef:
 - [Pins Jenkins to 1.555](https://github.com/erichelgeson/jenkins-chef-dsl/blob/master/recipes/default.rb#L13-L21) due to this bug  - <https://issues.jenkins-ci.org/browse/JENKINS-22346>

* [jenkins::java](https://github.com/opscode-cookbooks/jenkins/blob/master/recipes/java.rb)
 - Default java, nothing fancy here. Use the Java recipe for that.

* [jenkins::master](https://github.com/opscode-cookbooks/jenkins/blob/master/recipes/master.rb)
 - Installs a Jenkins Master

* [::plugins](https://github.com/erichelgeson/jenkins-chef-dsl/blob/master/recipes/plugins.rb)
 - Uses groups of wordlists to install plugins. I grouped dependencies together and added a ruby block to only restart. Dependencies are not resolved via the cookbook. [Pull Request #175](https://github.com/opscode-cookbooks/jenkins/pull/175)- that would do this but needs more work.

* [::auth](https://github.com/erichelgeson/jenkins-chef-dsl/blob/master/recipes/auth.rb)
 - Sets up Auth, there are a few examples included. Control via attributes.

* [::\_auth-basic](https://github.com/erichelgeson/jenkins-chef-dsl/blob/master/recipes/_auth-basic.rb)
 - Just basic auth, setup users before you add this!

* [::\_auth-github](https://github.com/erichelgeson/jenkins-chef-dsl/blob/master/recipes/_auth-github.rb)
 - Utilize the Github oAuth API to authorize users. Even works with Enterprise Github!

*  ::\_auth-ldap and others
 - Please add example implementations! Template for the Jenkins user's

* [.gitconfig](https://github.com/erichelgeson/jenkins-chef-dsl/blob/master/recipes/default.rb#L29-L34)

* [::chefdk](https://github.com/erichelgeson/jenkins-chef-dsl/blob/master/recipes/chefdk.rb)
 - Installs chef-dk(development kit) for all your chef testing goodness.

* [Sets up a bootstrap job](https://github.com/erichelgeson/jenkins-chef-dsl/blob/master/recipes/default.rb#L39-L52)
 - This [initial job](https://github.com/erichelgeson/jenkins-chef-dsl/blob/master/files/default/jenkins-job-DSL-bootstrap.xml)
will create all other jobs. This example job tests the Jenkins cookbook, but you
should keep the DSL script in a separate repo and clone that to build your jobs
(instead of inlining the scriptText)

* [::ruby\*](https://github.com/erichelgeson/jenkins-chef-dsl/blob/master/recipes/ruby.rb)
 - I initially tried to setup rvm and rbenv but ran into a few roadblocks,
then chefdk was released. They still may be a good starting point for someone
who needs to additionally manage a ruby environment. 

## Other Resources: 
(Fork this post and add more!)

* Setting up rubocop and foodcritic for chef cookbooks: 

<https://atomic-penguin.github.io/blog/2014/04/28/stupid-jenkins-and-chef-tricks-part-1-rubocop/>

* Jenkins Job DSL

<https://github.com/jenkinsci/job-dsl-plugin>
<https://github.com/jenkinsci/job-dsl-plugin/wiki>

* Jenkins DSL generator:

<http://job-dsl.herokuapp.com/>
