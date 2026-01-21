Eric Helgeson's Blog
====================

A Jekyll blog based on the Scribble theme.

---

## Development

This project uses a Nix flake for reproducible development environments.

### Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled
- [direnv](https://direnv.net/) (optional, but recommended)

### Quick Start

**With direnv (recommended):**
```bash
direnv allow    # First time only - loads environment automatically
bundle install  # Install Ruby dependencies
bundle exec jekyll serve --watch
```

**Without direnv:**
```bash
nix develop                          # Enter dev shell
bundle install                       # Install Ruby dependencies
bundle exec jekyll serve --watch     # Start dev server
```

Then visit http://localhost:4000

### Build Commands

```bash
bundle exec jekyll build    # Build the site to _site/
nix build                   # Build via Nix (output in ./result)
```

---

## Theme: Scribble

[Want a demo? click and read instruction.](http://scribble.muan.co/2013/05/06/scribble-the-jekyll-theme/)

![screenshot](http://scribble.muan.co/images/screenshot.png)

This theme uses Open Sans powered by Google Web Fonts, and was written in plain HTML, SCSS & CoffeeScript.

---

### Make it yours

1. I have extract most user specific information to `_config.yml`, you should be able to set up almost everything from it.
2. Change about.md for blog intro.
3. For domain settings, see [the guide from GitHub](https://help.github.com/articles/setting-up-a-custom-domain-with-pages).

---

### GitHub Pages stuff

The `gh-pages` branch of this repository is [the project page](http://scribble.muan.co), which **should not** be used as your blog, so use `master` branch for your blog. This is assuming your blog repository will be called [your-username].github.io, if tis is not the case, you will need to delete the `gh-pages` repository and create a branch off the `master` branch. Hope that's clear.

---

### Options

When writing a post, there are 3 options you can add to the header.

1. **disqus: y**<br />
  If disqus is set to 'y', at the end of the post there will be a disqus thread, just like this one. To use disqus, you MUST [set up your own disqus account](http://disqus.com/).

2. **share: y**<br />
  An option for showing tweet and like button under a post.

3. **date**: 2013-05-06 18:07:17<br />
  Date is not a required header since Jekyll reads the file name for date, this was added in only for the **signoff time**. (as shown at the end of this post) If you don't want the signoff time, go into `/includes/signoff.html` remove the `<span>`, and remove `{% include signoff.html %}` from `/layouts/post.html`.

---

### The end

Like it? [Tell me](http://twitter.com/muanchiou).<br/>
Question? [Use GitHub Issues](https://github.com/muan/scribble/issues).
