---
layout: post
title: Ubuntu 12.10 + Steam + ATI
excerpt: Get steam working on Ubuntu 12.10 with AMD. No frills just what to do.
category: blog
---

There's a lot of information that comes up when you search for running Steam on Ubuntu. A lot of it is old, doesn't work anymore, or tries to be so generic it covers every case. Well, i'll have none of that. This post works for me, and maybe you, but not for everyone. This should take you 20 min, instead of the 3 hours it took me trying things.

My setup:
* Ubuntu 12.10 64bit
* 2x ATI 5830's in CrossFire (should apply to any modern ATI cards)

Keep it simple:

1. Grab Steam (it wasn't in the software center for me) [http://repo.steampowered.com/steam/archive/precise/steam_latest.tar.gz](http://repo.steampowered.com/steam/archive/precise/steam_latest.tar.gz)

2. ATI Drivers
Just get the latest Beta, the ones in Ubuntu's proprietary and proprietary-updates are too old, and you won't have a good time. 13.2-beta7 was the lastest at the time I installed, find the latest here: 
[http://support.amd.com/us/gpudownload/linux/Pages/radeon_linux.aspx](http://support.amd.com/us/gpudownload/linux/Pages/radeon_linux.aspx)

Follow the guide below\[1\], but the jist is:
##### Get Deps: 
<pre>
$ sudo apt-get install build-essential cdbs dh-make dkms execstack dh-modaliases linux-headers-generic fakeroot
</pre>

You're on 64bit too, so get the 32bit libs
<pre>$ sudo apt-get install lib32gcc1
</pre>


##### Get Drivers:
<pre>
$ wget http://www2.ati.com/drivers/beta/amd-driver-installer-catalyst-13.2-beta7-linux-x86.x86_64.zip
$ unzip amd-driver-installer-catalyst-13.2-beta7-linux-x86.x86_64.zip
$ chmod +x amd-driver-installer-catalyst-13.2-beta7-linux-x86.x86_64.run
</pre>


##### Build Drivers:
<pre>
$ sudo sh ./amd-driver-installer-catalyst-13.2-beta7-linux-x86.x86_64.run --buildpkg Ubuntu/quantal
</pre>


##### Install (order matters):
<pre>
$ sudo dpkg -i fglrx_*.deb
$ sudo dpkg -i fglrx-amdcccle*.deb 
$ sudo dpkg -i fglrx-dev*.deb
</pre>


##### Configure:
<pre>
$ sudo aticonfig --initial -f
$ reboot
</pre>


##### Test!
<pre>
$ fglrxinfo
$ fgl_glxgears
# OOOO PURDY, Play Steam games now.
</pre>


##### I messed up and want to go back!
<pre>
$ sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
$ reboot
</pre>

#####Other
AMD adds a watermark on their experimental drivers, this is slightly annoying and can be removed fairly easily\[2\]:

<pre>
#!/bin/sh
DRIVER=/usr/lib/fglrx/xorg/modules/drivers/fglrx_drv.so
echo "Come on AMD!"
for token in $DRIVER; do
    echo "Removing AMD logo from "$token
    for x in $(objdump -d $DRIVER|awk '/call/&amp;&amp;/EnableLogo/{print "\\x"$2"\\x"$3"\\x"$4"\\x"$5"\\x"$6}'); do
        sed -i "s/$x/\x90\x90\x90\x90\x90/g" $DRIVER
    done
done
echo "Reboot computer to finish"
</pre>

Also with the beta7 I do get artifacts very minor artifacts on the desktop while not playing games. I'll live with it.

Something change or need to be updated? FORK THIS POST! See link below to fork and send a pull request.

\[1\] [http://wiki.cchtml.com/index.php/Ubuntu_Quantal_Installation_Guide#Installing_Catalyst_Manually_.28from_AMD.2FATI.27s_site.29_BETA.2FEXPERIMENTAL](http://wiki.cchtml.com/index.php/Ubuntu_Quantal_Installation_Guide#Installing_Catalyst_Manually_.28from_AMD.2FATI.27s_site.29_BETA.2FEXPERIMENTAL)

\[2\] [http://askubuntu.com/questions/206558/how-to-remove-the-amd-testing-use-only-watermark](http://askubuntu.com/questions/206558/how-to-remove-the-amd-testing-use-only-watermark)

