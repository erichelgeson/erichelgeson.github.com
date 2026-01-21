---
layout: post
title: The Missing guide to Enterprise APIs
excerpt: Tips, tricks, and gotchas from building "Enterprise" APIs
category: blog
---

Building an Enterprise API is much different than how startups build APIs. Enterprises have legacy systems, many SaaS vendors that store data, and data in multiple locations with multiple sources of truth. Such is the growth of any big company who is entering the API world. 

Though I've never seen tips, tricks or tutorials on how to deal with these real problems. You usually just see a .ppt file from the sales guy with box that says facade. Here are a few and I hope readers of this post can add more to it.

**Strip all but the headers needed when sending a request to a backend.**

You're likely facading one or many systems that can range from a decent REST service to POX with different layers in between. Some may barf at a cookie or a header they weren't expecting. Its better to explicitly strip them out.

**Cache keys are hard, and your API probably doesn't generate them well**

API platforms usually have a cache layer, are likely not just a plain old http cache, but more of an application layer cache. If your caching just on get parameters you'll do silly things like cache compressed responses and serve them to people who are not expecting them (Accept-Encoding) or if you use the Accept header for format, you'll serve json to someone wanting xml.

**Backend systems change, and they don't tell you**

These services were built way before people thought about web APIs. Yep, you got this beautiful service that is version 1, everything is fine then boom, the backend changes the POX service and requires a new field that won't fit into your new contract, and didn't tell anyone till you're all on a bridge because the service is failing. Unfortunately the only mitigation is Enterprise change management (threw up in my mouth a little typing that).

**Mashup of mashups of mashups**

This one may seem straightforward advice, but usually your API platform is the only way that two new systems can now interact, and thats a good thing, until someone wants to get a product (mainframe database), thats in a range of stores (well we have to geocode the address, then call another service), then the inventory lives somewhere else and only takes one product and location at a time. Oh ya and we only want ones where the driving distance (yep, another API) is 20 miles. Sounds sane right? Until you realize this results in 90 distinct API calls. And we need it in 2 weeks and has to perform in under 200ms... Advice? Start building an Operational Datastore or somewhere you can access the data quickly.

**Masking a service that always returns 200 is not all its cracked up to be.**

Good luck.

**Like-for-Like replatforming from a vendor is always more work**

But usually sold as less work. Two vendors in the same place can have wildly different concepts. Likely a major version of the API should be updated, but gets difficult when required to have old Apps work after the cutover. Put switches in your mobile apps to remotely change URLs so youre not waiting for your customers to update (they wont)

I know more of you have this knowledge in your head, fork this post below and share!
