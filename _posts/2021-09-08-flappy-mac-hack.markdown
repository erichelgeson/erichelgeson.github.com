---
layout: post
title: "Flappy Mac Hack"
excerpt: Lets hack Flappy Mac to get 100 flaps!
category: blog
---

[Flappy Mac](https://gruz.itch.io/flappymac), if you haven't seen, is a [Flappy Bird](https://en.wikipedia.org/wiki/Flappy_Bird) style game for the classic Macintosh created by Killgruz aka Jarrod Ford.

I am a horrible Flappy player, but an avid tinkerer. I decided to poke around and see if I could cheat and unlock all 10 characters without actually getting 100 flaps.

## Finding the Score

Poking around any classic Mac program you start up ResEdit and poke around to see what you can find. I wrote about some fond memories back in 2011 - ["cracking" the Descent app](/blog/2011/05/23/resedit/) so I didn’t need to use the original CD and could listen to some Weezer or NIN instead. 

<img alt="Flappy Mac opened in ResEdit." src="/static/images/flappy_mac_resedit.png">
<small><i>Flappy Mac opened in ResEdit.</i></small>

Once you open Flappy Mac in ResEdit you’re greeted with a list of resources - things that make up dialogs, windows, game data, and code for the game. The trick here is to find the resource that stored the score. I played till I got a score of 6 and started looking for a 6 somewhere in there...

The `DATA` forks are the most likely places for this to be stored, but it could be obfuscated or stored in some odd encoding. Luckily it was quite easy to spot `SDAT` (Save Data?) and I put the hex equivalent of 100 (`0x0064`) and low and behold I had a score of 100!

<img alt="Flappy Mac ResEdit score to 100!" src="/static/images/flappy_mac_resedit_edit.png">
<small><i>Flappy Mac ResEdit score to 100!</i></small>

## Creating the Patch

Being an avid Mac user in the 90’s I used my fair share of patches and hacks, but had never created one. I went looking at different cracks and patches till I found an app I’d forgotten - [ResCompare](https://macintoshgarden.org/apps/rescompare-v26)! 

<img alt="ResCompare 2.6 Folder/Icon" src="/static/images/flappy_mac_rescompare.png">
<small><i>ResCompare 2.6 Folder/Icon</i></small>

ResCompare allows you to take 2 files and compare resource differences between them:

<img alt="Comparing the original and the 100 flaps version." src="/static/images/flappy_mac_compare.png">
<small><i>Comparing the original and the 100 flaps version.</i></small>

After that you can create a executable patch file to share with others to patch the game without diving into ResEdit:

<img alt="A familiar patch icon to anyone in the mid 90's" src="/static/images/flappy_mac_patcher.png">
<small><i>A familiar patch icon to anyone in the mid 90's</i></small>

## Thanks and Download

Huge shout out to KillGruz for the Flappy Mac game, the permission to post this trainer, and the ride down nostalgia lane. If you’d like to download the patch file and become a no good cheater, click below:

<a href="/static/files/FlappyMacPatch.sit.hqx">
<img alt="Cheater!" src="/static/images/flappy_mac_100ss.png">
</a>
<small><i>Cheater!</i></small>

<a href="/static/files/FlappyMacPatch.sit.hqx">FlappyMacPatch.sit.hqx </a>

## Another Option

I also checked out the much newer (2020) [ResPatch](https://macintoshgarden.org/apps/respatch-10) and was able to create a patch which I included in the archive as well. 
