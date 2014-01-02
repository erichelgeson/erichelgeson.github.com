---
layout: post
title: DNS Security Colaberative Post
excerpt: DNS Security Colaberative Post
disqus: n
category: blog
---
There was a ton of responses to my blog post about my [ISP's bad behavior with DNS](http://erichelgeson.github.io/blog/2013/12/31/i-fought-my-isps-bad-behavior-and-won/) and I wanted to consolidate the information here. This post is on github so you can [click here](https://github.com/erichelgeson/erichelgeson.github.com/blob/master/_posts/2014-01-02-dns-security-colaberative-post.markdown) to add or edit any info in this post, just a pull request away (just follow the same formatting). I'll be adding more as I parse through all the comments.
<hr/>

Basics of DNS
--
**What is DNS**

<https://en.wikipedia.org/wiki/Domain_Name_System>
<http://computer.howstuffworks.com/dns.htm>

**ELI5**

<https://pay.reddit.com/r/technology/comments/1u4b49/i_fought_my_isps_bad_behavior_and_won/ceei22w>
>Think of a DNS as a phonebook from the days of old. You knew the name, but you didn't know the number. You couldn't just speak the name into the phone (back then), so you looked up the number in the phonebook and then dialed it. Nowadays, the computer likewise can't just go to "www.amazon.com". It asks a DNS for the "number" for amazon.com (which as of now, for me, is 72.21.194.212), then communicates with that IP address, which is known to you as Amazon.

**Why is this important?**

DNS in its current form is one of the weakest links in privacy and security of your Internet connection. DNS lookups is one of the first things that happens when you browse to a site so if it is compromised your entire session can be hijacked. This can be used to insert ads or affiliate links into your browsing session or even proxy all of your connections through a host and watch all of your traffic.
<hr/>

Current DNS Security Options
--
DNSSEC
---
> ... a set of extensions to DNS which provide to DNS clients (resolvers) origin authentication of DNS data, authenticated denial of existence, and data integrity, but not availability or confidentiality
<https://en.wikipedia.org/wiki/Domain_Name_System_Security_Extensions>


**Deployment**

DNSSEC currently does not have widespread adoption and solves only that the record served to you was what the original site intended, but could easily be removed without the end user knowing.

<http://dnssec-debugger.verisignlabs.com/comcast.com>

**Questions**

* If DNSSEC validation fails, is the end user show a warning like SSL?
 * Chrome (but doesn't seem to work) <https://chrome.google.com/webstore/detail/dnssec-validator/hpmbmjbcmglolhjdcbicfdhmgmcoeknm?hl=en>
 * Firefox <https://os3sec.org/>

**Testing DNSSEC**

<http://dnssec-debugger.verisignlabs.com>
<http://dnsviz.net/d/google.com/dnssec/>

<hr/>
DNSCrypt
---
<https://DNSCrypt.org>
<https://www.opendns.com/technology/dnscrypt/>

**Support for DNSCrypt**

>The daemon is known to work on recent versions of OSX, OpenBSD, Bitrig, NetBSD, Dragonfly BSD, FreeBSD, Linux, iOS (requires a jailbroken device), Android (requires a rooted device), Solaris (SmartOS) and Windows (requires MingW).
<https://github.com/jedisct1/dnscrypt-proxy#installation>

**Routers**

OpenWRT <http://wiki.openwrt.org/inbox/dnscrypt>

<hr/>
DNSCurve
---
<http://dnscurve.org/>
>Confidentiality: DNS requests and responses today are completely unencrypted and are broadcast to any attacker who cares to look. DNSCurve encrypts all DNS packets.
>
>Integrity: DNS today uses "UDP source-port randomization" and "TXID randomization" to create some speed bumps for blind attackers, but patient attackers and sniffing attackers can easily forge DNS records. DNSCurve cryptographically authenticates all DNS responses, eliminating forged DNS packets.
>
>Availability: DNS today has no protection against denial of service. A sniffing attacker can disable all of your DNS lookups by sending just a few forged packets per second. DNSCurve very quickly recognizes and discards forged packets, so attackers have much more trouble preventing DNS data from getting through. Protection is also needed for SMTP, HTTP, HTTPS, etc., but protecting DNS is the first step.

<hr/>
Alternative DNS providers
---
<https://developers.google.com/speed/public-dns/>
<http://www.opendns.com/>

**Concerns when using other DNS providers**

Using an alternative DNS can potentially interfere with CDN's (Content Delivery Networks)
Alternative DNS's systems may provide faster lookup times but there are other factors to consider: <https://news.ycombinator.com/item?id=6993980>

They could also be tracking and using this information.

**DNS Benchmarking**

<https://code.google.com/p/namebench/>

<hr/>
Ideas
---
* Crowd-source Poisoned DNS like invalid ssl certs, chrome extension that reports dns async?

<hr/>
VPN's
---
Not a solve for DNS security, just moves the concern to your VPN provider from your ISP.

