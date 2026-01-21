---
layout: post
title: Photo Backup
excerpt: How I'm backing up my Photos
category: blog
---

3-2-1 Backup Rule, 3 copies, 2 media types, 1 offsite.

Current state is I have one copy, on 1 media type, on site. Not a good solution.

While I ponder what plan to buy from CrashPlan and how long 200GB will take to upload, I'm making a backup to DVD which I'll store offsite. I'll do this quarterly deltas.

I couldn't find a good backup solution (good == free, and no weird archive format) I chose to go the old fashion way, tar + split:

* tar cvf /Volumes/500GB/20110724.tar Photos/
* split -b 2240m 20110724.tar 20110724.tar.split.
* burn resulting files (2 per dvd)

Things to note:

* no compression, doing this for speed, not for saving space
* no parity, if I corrupt a file then it's gone, but tar can recover if just some bits are wrong and only lose part of the files in the archive.
* no cryptography, could run it through something

This is one step toward my ideal backup solution:

3 Copies -

Crash Plan - Cloud
Crash Plan - NAS HDD
DVD
2 Media types - HDD & DVD

2 Offsite - Crash Plan Cloud & DVDs
