---
layout: post
title: Chef Feature Flags using Attributes
excerpt: Chef Feature Flags using Attributes
category: blog
---

I first saw this pattern in Fletchers presentation [Test Kitchen: One Year Later and the Future](https://www.youtube.com/watch?v=YzlCHAbJ7KM) at ChefConf 2014. There he showed how to make Chef-Solo and Chef-Zero happy together when using a search. This is useful when using ChefSpec as it runs as a ChefSolo run:

```ruby
# if the node attribute is set, use its value, else use the search
search_results = if node['search_results_override']
                   node['search_results_override']
                 else
                   search(:node, '*:*')
                 end
```

This gives us the ability to set a node variable in ChefSpec, kitchen.yml, Vagrantfile, or even a role file in an environment to override what that search will return.

```ruby
# Just an empty hash, or stub out the response
default['search_results_override'] = {}
```
or a `.kitchen.yml`

```
attributes:
  search_results_override: {}
```

As Fletcher said, chef-server `:)`, chef-solo `:))`.

Now lets take this concept a bit further. In production you want to deploy a change to one node in your cluster to verify a change before deploying it to the whole cluster? A canary build.

```ruby
my_version = if node['myapp']['version_override']
               node['myapp']['version_override']
             else
               node['myapp']['version']
             end

package "myapp" do
  version my_version
end
```

And create a role `my_app_canary.rb` with:

```ruby
default['myapp']['version_override'] = '1.0.2'
```

You could even have Jenkins create and apply this role for you to orchestrate your deployments.

Or this example for using an non-encrypted databag in non-prod, or encrypted in production from ChefSugar's [README.md](https://github.com/sethvargo/chef-sugar#examples-7)

```ruby
credentials = if in?('production')
                Chef::EncryptedDataBag.new('...')
              else
                data_bag('...')
              end
```

The nice thing about using this pattern instead of using the [15 levels of attribute persistence](https://docs.getchef.com/chef_overview_attributes.html) you use a different node attribute, which can be set in roles, environments, cookbooks, Kitchen.yml, Vagrantfiles or where ever you need. Also it can be added or removed from nodes after your deployments or upgrades.
