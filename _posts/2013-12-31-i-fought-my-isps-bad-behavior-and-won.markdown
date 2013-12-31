---
layout: post
title: I fought my ISPs bad behavior and won
excerpt: How I took on my ISPs deceptive affiliate URL injection.
category: blog
---

Just before black friday I was surfing some major retailers sites and on a whim wanted to see how they were using javascript/css/ajax/cdn's on their pages. I opened up Chrome Inspector and loaded a few pages. I noticed the first hit on a few of the sites was to proxy.fwdsnp.com, which seemed odd, maybe it was an analytics site I'd not heard of?

When looking at the URLs a little more closely I noticed fwdsnp was adding affiliate ID's into the URLs. Did I have some malware that was hijacking my requests?  I switched to Google's DNS and the affiliate IDs were not injected into the URLs. Then I noticed one of the affiliate's name was Arvig, which happens to be my ISP. **Confirmed**. It looks like I'm not the only one[1].

A whois of fwdsnp.com pointed me to <http://www.aspiranetworks.com/>, a company that provides:

> *... technology is easy-to-integrate, delivers revenue to you and enhances the online shopping experience for the users on  your network...*

Sounds like something a coffee shop or public wifi might do, but not an ISP I pay $80/month for.

**How they were doing it**

It appears that the method they were using was to poison the A record of retailers and do a 301 redirect back to the www cname. This is due to the way apex, or 'naked' domain names work <https://devcenter.heroku.com/articles/apex-domains>.

Example:

* GET http://amazon.com
* DNS returned is for proxy.fwdsnp.com
* 302 redirect to http://www.amazon.com/?affiliate=id
* DNS returned is now www.amazon.com, which would return a real Amazon.com IP address

**Contacting Arvig**

I had previously chatted with a director at Arvig about a fiber install, so I emailed him directly with the information above. The response on the issue was less than encouraging.

>Hi Eric,

>Thanks for letting us know about your concerns. I can respond to both.

>We have been trialing the DNS redirection arrangement that you noticed, and will more than likely continue forward with it. We work with a third party who has contracted with large internet merchants, including Target, to deliver coupon offers to our customers who allow browser pop-ups. Customers blocking pop-ups do not see the coupons. The response so far has been overwhelmingly positive (in view of the number of customers who have taken advantage of savings by using the coupons).

>We have not seen any noticeable latency so far, but we are prepared to bypass the redirection should that be the case. We have also set up two DNS servers that do not redirect and you may want to use those in lieu of our defaults. They are: *removed*

>Please feel free to contact me directly if you would like to discuss this further.

>Thanks again for taking the time to write to us.

>Bill.

Viewing this as a value add to their customers and have no plans to discontinue. I was free to use a different DNS provider if I liked.

I was disheartened at their response. If they wanted to continue to do this and saw it as valuable, how could I convince them to change? 

**Contacting the retailers directly**

Then I had an idea. This practice can't be viewed as legitimate affiliate traffic for the retailers! I could contact them directly and see if they'd take action.

I contacted two major retailers affiliate programs and gave them the logs and a description of what happened. They quickly responded and indicated they'd take action right away. I can confirm as of last week that from the top 1000 Alexa list, no DNS record are being hijacked anymore[2].

If you are a retailer or have an affiliate program
An easy way to find out if you're being taken advantage of in the same way is if you see a Referrer header with proxy.fwdsnp.com in it.

**What next?**

I sent them a response on Dec 10th 2013 but have yet to hear back:
>Hi Bill, thanks for responding so quickly.
>
>I've had time to think about your response and I hope I can make my position clear that I believe what you are doing is wrong at best, and fraudulent at worst. I have talked to both users of Arvig as well as professionals in the referral business about this practice and it has been met with strongly negative sentiment.
>
>I have contacted the referral abuse email addresses at many of the retailers you are injecting the referral link and will continue to contact them as I find more that are being poisoned. I trust they will take the appropriate action from my conversations with them, if not already.
>
>You provide a service to people, giving them a connection to information. Focus on doing that well. Build faster connections at cheaper prices and greater reliability. This is what your customers value in the long run, not quick make a buck tactics.
>
>I sincerely hope you reconsider this practice as it is not a sustainable solution.
>
>Thanks,
>-Eric.

I hope after you read this you'll check your ISP too and see if they are intercepting your traffic. Some tools you can use are:
<http://broadband.mpi-sws.org/transparency/glasnost.php>
<https://code.google.com/p/namebench/> (thought CDNs get are sometimes shown as censorship)

This also shows a weakness in DNS. There is currently no way to validate the DNS record you're being served is what the person hosting the website intended. An ISP could hijack all DNS requests to use their servers in which case you could not bypass them. My ISP could easily at their routers reroute all DNS traffic to theirs so I could not bypass them. 

I will continue to monitor periodically their DNS entries and compare them with other public DNS servers.[2] As well as monitor for any changes to their TOS or Net neutrality statements (both IMO are not consumer friendly).

You may be asking why don't I switch ISPs? Well they are the only one besides a wireless provider in my area.

ISP's ask you to not do crummy things on their networks, so how about they don't do the same to their customers?

**Notes**

[1] - <http://superuser.com/questions/652995/why-does-my-browser-try-to-open-ads-from-fwdsnp-com>
[2] - Script I used to to compare the top 1000 sites, requires curl compiled with ares (port install `curl +ares on macports`) for using different dns-servers.
{% highlight bash %}
for i in `head -n 1000 top-1m.csv | cut -f2 -d,`; do 
  echo "Site: $i"; 
  diff  <(curl --ipv4 -s -v --dns-servers 66.x.x.4,66.x.x.4 --url http://$i/ 2>&1 | grep -v "0x" | grep -v "Date: ") <(curl --ipv4 -s -v --dns-servers 8.8.8.8,8.8.4.4 --url http://$i/ 2>&1 | grep -v "0x" | grep -v "Date: ");
done > 1000.diff.txt
{% endhighlight %}
