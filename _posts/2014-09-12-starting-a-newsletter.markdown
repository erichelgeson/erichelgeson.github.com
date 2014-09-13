---
layout: post
title: Starting a newsletter
excerpt: My experience starting and running a newsletter for the past 8 months.
category: blog
---
Back in January 2014 I started the newsletter [UsingChef](http://usingchef.com/?ref=ericblog) to see if I could build a successful newsletter. Partly because I wanted a side project and partly to give back to a community I'm involved in every day. It's been about 8 months and I'd have to say it is a small success. I wanted to share some details on the what and how I've been running the newsletter and hopefully help someone else out if they're thinking about doing it.

## Getting started
### Finding your niche
This was easy for me, and I think if you're trying too hard you don't have a niche yet. You likely use a product, programming language, or utility every day that others use too. If people start looking to you and asking you questions on how to use it, thats a great idea to start a newsletter.

Time commitment is another thing to consider. Before I started automating many of the things below it could take me between 1.5 to 2 hours of time every Sunday. I usually did this while the kids were napping or playing, but you need to commit to this each week. Durring the last few weeks I've actually gone to bi-weekly to spend more time with my family. (Good thing I didn't call it Chef-Weekly :)

## Getting and automating content
Most of my content comes from Blogs and Twitter. I use Feedly to categorize blogs and favor content I want to mark for inclusion. On Twitter I favorite posts. Really keep it simple.

The interesting part is these two services have APIs that I can pull my content and aggregate it in a format I can use to publish. There was an awesome [Lifehacker post](http://lifehacker.com/twitter-archiver-saves-tweets-by-keyword-or-hashtag-in-1598972400) on how to use Google Sheets and a Script to pull in a Twitter search. I took that idea and applied it to my favorites and expanded it quite a bit.

### [Twitter Favorite Script](https://gist.github.com/erichelgeson/a0a0d34e195b823f7bd1)
* Grabs new favorited tweets every 15 min
* If there is a URL in the tweet, call that URL and grab the title from the HTML. 99% of the time I use that as the title in the newsletter.
* Format the content for my Jekyll include (more on that in a bit)
* Save it as a row in a Google Doc Sheet
* The Sheet is conditionally formatted so I can quickly see only favorites in the past week. (Newsletter is ~Weekly)

I did try [IFTTT](https://ifttt.com/) and [Zapier](http://zapier.com) but neither gave me access to the attributes I wanted or the ability to do additional processing, as well as I'm comfortable writing code and Google is hosting and scheduling the script for me.

I also looked at [Apache Camel](https://camel.apache.org/), but the learning curve was a bit high for this project and the Twitter4J adapter wasn't wired up for favorites.

For Feedly, I do not have a paid account right now so I Tweet the entry, usually from the mobile app, then favorite it from Twitter so it is picked up.

## Platform
### Newsletter
[Mailchimp](http://eepurl.com/MRMJD) provides a free tier for getting started and honestly works quite well. For formatting and templates I kept it simple and copy/paste right from my site. Mailchimp provides some good metrics an analytics for opens, links clicked, among other things.

I've also started to get into some newsletter optimization. What happens if I send on a Monday morning instead of Sunday afternoon? Do I get more opens? (yes!) Mailchimp again has some premium features to help with this type of testing, but I haven't played with them yet.

### Blog
In addition to a newsletter I setup an accompanying blog to post. Use what you know. I've setup a few [Jekyll](http://jekyllrb.com/) sites before so I created another one. I found a CC theme that looked good and customized it from there. The hardest thing was integrating the CSS from the mailchip button to look the way I wanted it to.

I use the blog to write and format the comment. Much of my time in the beginning was spent fixing markdown formatting and missing quotation marks and ensuring there were 4 spaces instead of 2 or a tab.

To address this I started using Jekyll includes for [articles](https://github.com/usingchef/usingchef/blob/master/_includes/article.html) and [releases](https://github.com/usingchef/usingchef/blob/master/_includes/release.html) so I can pass in the content and the include does the formatting. I didn't start this until newsletter #13, I really should have sooner.

Now things get really interesting. Since I'm getting all my data from an API, I can transform it into the API I've defined in these includes! That means if everything works right I can just copy/paste from the Google Sheet and fill in the commentary. Saves a ton of time.

Lastly [feedburner](http://feedburner.com) for RSS stats. Have quite a few like me who still use RSS for their main source of news.

#### Hosting
For hosting the site I have a small $5/mo [Digital Ocean](https://www.digitalocean.com/?refcode=ed172ee8d6f0) box setup with Nginx, fronted by the free tier of [Cloudflare](http://cloudflare.com) incase I would mess up or have to restart the box for an update.

#### Deployments
Before last week I was committing and pushing changes to bitbucket for a backup and then copying the files over manually, then copying them into the www directory on the server. This got cumbersome and error prone (luckily(?) I dont get enough traffic if I mess up a deployment and Cloudflare will protect me as well).

I've changed to a git post-recive hook. Now all I do is `git push digitalocean` and it is deployed. Here's a great tutorial on how to set it up yourself: <https://www.digitalocean.com/community/tutorials/how-to-deploy-jekyll-blogs-with-git>.

I've also moved all the content of the blog to a public Github to allow others to see how I've set things up and even do a pull request on the newsletter to fix a link or a typo.   <https://github.com/usingchef/usingchef>

## Lessons learned

Sweat the small stuff but don't be afraid to publish. The first newsletter I had my wife read and I read about a hundred times and I had my coworker read it as well. Email does not have an edits or take backs.

Create some goals and hypothesis for yourself early on. I was happy when I got to 10 subscribers, but now I'm over 400 and growing more each month. The community is a fairly small tech community but it is quite active. I think it will get to 800 by the end of the year.

Create content yourself. You are part of the community, contribute to it. Don't just be a content aggregator.

I did get banned from [r/devops](http://reddit.com/r/devops) for posting my own content. I unfortunately did not read their content policy and was posting my own creation. I asked nicely and the ban was lifted. Reddit though did drive a lot of my traffic.

When the first subscriber unsubscribes, its sad, but don't let it get down. If your content is interesting they will be replaced 10 fold. I had a recently unsubscribe with the feedback "spammy". I have no idea why but I don't let it bother me. Now if I unsubscribe from a newsletter I try to give them useful feedback, you should too.

Privacy policy, likely not needed because of Mailchip is good at detecting abuse but will put out there anyways. I do not share emails with anyone.

I have not done any advertising to date. There are nominal costs to running it (time/hardware/etc). If I was approached to put an advertisement in that was explicitly called out as an ad on the newsletter, and something non-spammy, I likely would.

Write about what you're doing every ~6-8 months. You'll learn a lot and it's fun to share.

Automated early and often save yourself time and frustration in the future.

So are you thinking about starting your own newsletter? Do it! There's a lot of resources out there to get started. Share what you know with others. Have questions for me? Reach out, I'd be happy to chat.

Oh, and if your a Chef user or interested in Chef, checkout [UsingChef.com](http://usingchef.com/?ref=ericblog) and sign up!
