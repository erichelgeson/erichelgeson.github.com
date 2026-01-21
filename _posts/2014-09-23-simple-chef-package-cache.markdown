---
layout: post
title: Simple Chef Package Cache for Kitchen
excerpt: Simple Chef Package Cache for Kitchen
category: blog
---
There is many times you have limited or slow internet access, but still need to converge a machine. And each converge it downloads and installs the Chef-Client which can take quite a while. Here's a hacky way to share your `/tmp/kitchen/cache/` dir with the host machine to reduce download times in your converge.

`kitchen.local.yml` -

```
driver:
  # Share a local folder
  synced_folders: [
    ["./chef-pkgs", "/tmp/chef-pkgs"]
]

provisioner:
  # curl accepts a local file:// url
  chef_omnibus_url: file:///tmp/chef-pkgs/install.sh
```

`chef-pkgs/install.sh` -

```bash
# Stub install.sh
# TODO: make this smarter, though works
# sudo dpkg etc.
sudo rpm -ivh /tmp/chef-pkgs/chef-11.12.8-1.el6.x86_64.rpm
```

I've also shared the `/tmp/kitchen/cache`, though this won't cache `yum`/`dpkg` or if files are downloaded directly to other locations. If you want give it a try:

```
driver:
  # Share a local folder
  synced_folders: [
    ["./cache", "/tmp/kitchen/cache", 'owner: "vagrant", group: "vagrant"']
]
```

You can also checkout a way to setup a simple local http proxy in kitchen. I've gotten it to work, but usually forget to turn it on! <https://gist.github.com/fnichol/7551540>
