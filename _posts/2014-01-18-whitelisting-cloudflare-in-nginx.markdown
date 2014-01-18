---
layout: post
title: Whitelisting CloudFlare in Nginx
excerpt: Whitelisting CloudFlare in Nginx
category: blog
---
I recently moved from Apache2 to Nginx as my web server of choice because of its low memory footprint so I can run it on a very small [Digital Ocean](https://www.digitalocean.com/?refcode=ed172ee8d6f0) Droplet (thats a referral link, here's a direct link <https://www.digitalocean.com>)

CloudFlare is a Content Delivery Network ([CDN](https://en.wikipedia.org/wiki/Content_delivery_network)) provider and has a free tier, which is great to protect my lttle droplet. And to protect it even more you can white list CloudFlares IP's. 

To do this, create a file that allows all of CloudFlare's IPs. You can then include it into your nginx config. If you have multiple sites you can include them in each or globally or per site.

Create `/etc/nginx/cloudflare-allow.conf`
{% highlight bash %}
# https://www.cloudflare.com/ips
# IPv4
allow 199.27.128.0/21;
allow 173.245.48.0/20;
allow 103.21.244.0/22;
allow 103.22.200.0/22;
allow 103.31.4.0/22;
allow 141.101.64.0/18;
allow 108.162.192.0/18;
allow 190.93.240.0/20;
allow 188.114.96.0/20;
allow 197.234.240.0/22;
allow 198.41.128.0/17;
allow 162.158.0.0/15;

# IPv6
allow 2400:cb00::/32;
allow 2606:4700::/32;
allow 2803:f800::/32;
allow 2405:b500::/32;
allow 2405:8100::/32;
{% endhighlight %}


Then in your `sites-available/site.com` add:

{% highlight bash %}
server {
  listen 80; ## listen for ipv4; this line is default and implied
  listen [::]:80 default ipv6only=on; ## listen for ipv6

  include /etc/nginx/cloudflare-allow.conf;
  deny all;

  server_name direct.site.com www.site.com site.com;

  #...the rest of your config here...
}
{% endhighlight %}


Thats it, now when access the page via your `direct` hostname, it will give a [403 Forbidden](https://en.wikipedia.org/wiki/HTTP_403). Note this is still a hit to origin and nginx will process it. I did this approach as I have some other hosts not in front of CloudFlare.

Alternatively you can use iptables to drop all packets not from CloudFlare <https://support.cloudflare.com/hc/en-us/articles/200169166-How-do-I-whitelist-CloudFlare-s-IP-addresses-in-iptables->

### Links:

More info on ngx\_http\_access\_modlue which provides the allow/deny: <http://nginx.org/en/docs/http/ngx_http_access_module.html>

Setting up virtual hosts in nginx: <https://www.digitalocean.com/community/articles/how-to-set-up-nginx-virtual-hosts-server-blocks-on-ubuntu-12-04-lts--3>
