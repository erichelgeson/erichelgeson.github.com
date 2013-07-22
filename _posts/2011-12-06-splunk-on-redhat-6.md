---
layout: post
title: Installing splunk on RedHat 6
excerpt: Installed splunk 4.2.x on redhat 6 today and here's some notes.
category: blog
---
Installed splunk 4.2.x on redhat 6 today and here's some notes:

* As of today I don't think splunk is certified on rhel6. [http://splunk-base.splunk.com/answers/11233/when-will-splunk-support-solaris-11-and-rhel-6](http://splunk-base.splunk.com/answers/11233/when-will-splunk-support-solaris-11-and-rhel-6)
* I disabled SElinux and set splunk to ignore SELinux warnings (i used the grub method) [http://www.crypt.gen.nz/selinux/disable_selinux.html](http://www.crypt.gen.nz/selinux/disable_selinux.html) & [http://www.splunk.com/support/forum:SplunkAdministration/3147](http://www.splunk.com/support/forum:SplunkAdministration/3147)
* redhat 6 seems to have iptables on very restrictive by default, I'm in a lab so I disabled iptables for now.

All in all a pretty simple install, just a few gotchas since I'm not a redhat man.
