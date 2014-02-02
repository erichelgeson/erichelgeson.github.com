---
layout: post
title: Attributes and string interpolation in Chef
excerpt: Attributes and string interpolation in Chef
category: blog
---
When your attributes contain a lot of [string interpolation](https://en.wikipedia.org/wiki/String_interpolation) it can be confusing to know why some note attributes have one variable and other have another. This is due to when the attributes file is evaluated. 

The latest java cookbook creates the string attributes in a recipe vs. the attribute file, which can alleviate some of these issues.

Recipe to set attributes:  
<https://github.com/socrata-cookbooks/java/blob/master/recipes/set_attributes_from_version.rb>

Attributes with no string interpolation:  
<https://github.com/socrata-cookbooks/java/blob/master/attributes/default.rb>
