---
layout: post
title: bash - test syntax before execution
excerpt: Shoulder surfing an experienced shell user always leads to "how did you do that!?" or "oo that's cool, never tried that before"
category: blog
---

Shoulder surfing an experienced shell user always leads to "how did you do that!?" or "oo that's cool, never tried that before"

So here's a quick tip I learned a while ago:

Say you want to run a loop to do something with some input, and you want to make sure it's right before you execute it 100x. Lets take this simple example, make 10 directories named 1..10 each with 10 sub dir's named 1..10.

To test this we can make the loop, but instead of running the command, echo out the command:

{% highlight bash %}
$ for i in {1..10}; do for n in {1..10}; do echo 'mkdir -p $i/$n'; done ; done
mkdir -p 1/1
mkdir -p 1/2
...
mkdir -p 10/9
mkdir -p 10/10
$
{% endhighlight %}

Great, that's the 100 commands we wanted to run printed to the screen. Now here's the trick, instead of editing out the echo command just pipe it through your shell:

{% highlight bash %}
$ for i in {1..10}; do for n in {1..10}; do echo 'mkdir -p $i/$n'; done ; done | bash
$
{% endhighlight %}

Volla! You've just created 100 dirs.
