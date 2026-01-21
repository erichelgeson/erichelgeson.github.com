---
layout: post
title: Setting up a Steam Machine
excerpt: My experience setting up a DIY Steam Machine while waiting for the official one.
category: blog
---

I sold my Xbox Series X recently for $350 – it was hard to get someone local to bite even at that price with two controllers and a stack of games. Now Xbox is a dead platform with the price hikes and lack of really any compelling exclusives against my massive Steam library meant the Steam Machine could be a huge win. 

I run Linux on my desktop via NixOS, so I thought I might try to setup and use a Steam Machine now while we wait for the [official Steam Machine](https://store.steampowered.com/sale/hardware) in 2026. 

Steam in the living room currently has rough edges. I bought ([and returned](https://tinkerdifferent.com/threads/steam-deck-not-ready-for-prime-time-or-gamer-families.2200/)) a Steam Deck early on as I really like the concept and the path Valve is heading. It was just too complex for me and my family to use. One of the main reasons I wanted it was so my kids could play a game on it while I played a game on my PC. But it locked my library when I was playing so only one machine could use it. They’ve made changes to family sharing but if it’s not as simple as a Nintendo Switch or at most an Xbox for switching accounts, it’ll be a huge fail.

Xbox, Nintendo, and Sony have had years of experience to polish the living room console experience, we’ll see if Valve can come close.

I've detailed the technical details of my setup at the end of this post.

## Living room experience

Valve is really selling the Steam Machine as being a living room device and console like experience. Steam currently fails at this hard.

### Family Sharing

Steam has made updates in this regard since I last used it but it is still not as simple as “I own a game, anyone can play it if they’re on a device I own.” Anyone can play Mario on my Switch if they come over and spend one minute setting up a local account.

To be a living room device you can't spend 20 minutes to sign up your cousin for a Steam account on Christmas eve to get in to play some games.

#### Adding a new user

Adding a new Steam user to my machine is quite complex - something I think a non-technical person would really struggle with. 

I have four children and I started with my son. Signed up for an account in a web browser, auth codes back and forth. 

Now to add him as a friend using just the browser was a pain. I had his account in one incognito window and there seems to be no way to add friends on the web interface. I had a friend code, no where to put it. I finally saw and copied the “friend link” and pasted it into the incognito window and was added. My “Manage Family” or “Friends List” didn’t update till I manually reloaded the pages, not a great UX. Then to finally accept the family invite you had to copy a large verification number back into his account.

Even setting up the account he wanted a username, now usually a system with unique usernames will just “hide” the number for you, but since it’s a login too you have to choose a unique one, and it chooses non-unique ones oddly for you. Not a great UX.

We wanted an avatar, and it seems some games in my library had some available. But.. they were not great, and from games I didn’t even know I had. Finally found one and clicked it (but you have to also click save even though it shows it set as your avatar). Steam needs a list of nice avatars for people to pick from for new accounts. Again this is not a great UX.

Compare this to Nintendo or Xbox and they are miles ahead here. Switch with a local account or a “Guest” on Xbox is about a 1 minute task.

### Split screen

This is a big gap between the version of Steam games and console games. Consoles have couch co-op split screen setups, but the same PC games do not.

For example Baldur's Gate 3 my daughter and I were playing through this on Xbox split screen. I grabbed the save file from the Xbox  (huge shout out to Larian Studios for allowing cross platform saves and storing the last 10 online to grab!) but now I need two computers and two copies of the game.

Minecraft is another one – no split screen on PC.

### Power on/off

People are not used to "computerisms" anymore. These days you just hit the power button when you’re done and again to start and it’s instantly on. 

My kid turned on the controller and was confused why the TV didn’t turn on. Sure this is a limitation of my setup but I hope the Steam Machine will power on when the controller connects (though probably only when _their_ controller connects). Another thing Xbox gets right here is pairing controllers to users – so if you turn on the Xbox with your green controller your profile will be the one loaded up.

After he was done gaming he didn’t really know you had to “quit” a game, that concept is foreign to console users. You just hit the home button or directly turn off the console. I believe the Steam Deck handles this gracefully (though I don’t think all games can suspend/resume gracefully). 

## Controllers

There is no real common SDK for all PC games to use for inputs and even when they do use the Steam Input there are issues.

* When controllers die I am unable to pick up a new controller and continue on. Even charging up the old controller or physically connecting it via USB I am unable to continue the game without quitting and restarting. I did try to cycle steam input as the controller DID work with Steam, just not the running game (Clair Obscur: Expedition 33) 
* When to use steam input or not? Some games require it, some don’t, and expecting my 7 year old who wants to play Portal to figure that out is a bridge too far. He just wants to play games.
* Multiple controllers does not have a UI for picking who’s using which controller or to re-assign a controller, or add a 3rd or 4th later.
* No low battery indicator

### Xbox controllers

I personally just like the feel of the current gen Xbox controllers, but they are not a good choice for a steam machine:

* Updates can only be done via an Xbox or Windows PC. I have neither.
* I eventually got a KVM USB pass through to work, but it was not trivial.
* An update was required to use one of my controllers as it would not pair with my Linux PC.


## VR

I have a Rift S that the family has fun playing games, unfortunately since the Meta login requirement we’ve not used it much and I haven’t tried to use it on Linux. Another item to sell locally. I am looking forward to Steam’s offering here.

## Games

Not all games are really optimized, even first party Valve games, for Big Picture or controller first/only setups.

Portal (1)
- Unable to “apply” settings in controller mode (A to apply and also A to cycle options, doesn’t work!)
- Multiple players on multiple controllers have issues and sometime I have to use Steam Input and sometimes not. Not trivial for kids to setup.

## Steam Machine setup

I’m using my Desktop PC with NixOS unstable on it and used a long HDMI cable to go to my living room TV. To make this usable for the family I setup a little Pico-W with a button that, when hit, will tell my PC to turn on the TV, switch the inputs, open Steam in Big Picture mode. Press it again and it will set everything back.

## The good

I can backup my saves any way I wish – I'm currently using [Ludusavi](https://github.com/mtkennerly/ludusavi) to backup and then it's backed up off site.

I can use a keyboard and mouse if I want to – controllers are great, but I'm not going to be playing DOOM or any other FPS with them. Consoles occasionally allow non-controller inputs, but it's the exception.

## Hope

The good news is Steam has a huge library of fun games. Almost all the games I want to play with Proton. I've played through AAA games hours and hours and it's fun. That part they have figured out, but they now need to translate this to the living room.

Can Valve pull this off or will it just be a Linux PC I have to manage for my family? 2026 will tell.

