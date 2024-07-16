---
title: Hexo
top: false
cover: false
toc: true
description: Configure Hexo
categories:
  - Programming
  - Tools
  - Hexo
tags:
  - Hexo
  - Blog
abbrlink: b132932
date: 2022-06-12 16:53:47
password:
summary:
---

# Enable Gitalk

I use the `Next` theme of `hexo`.

Modify the `_config.yml` of `next`.

Use gitalk as the comment system.

```yml
comments:
  # Available values: tabs | buttons
  style: tabs
  # Choose a comment system to be displayed by default.
  # Available values: disqus | disqusjs | changyan | livere | gitalk | utterances
  active: gitalk
  # Setting `true` means remembering the comment system selected by the visitor.
  storage: true
  # Lazyload all comment systems.
  lazyload: false
  # Modify texts or order for any naves, here are some examples.
  nav:
    # disqus:
    #  text: Load Disqus
    #  order: -1
    gitalk:
      order: -1
```

Enable gitalk.

```yml
# Gitalk
# For more information: https://gitalk.github.io
gitalk:
  enable: true
  github_id: xyegithub # GitHub repo owner
  repo: hexo_comment # Repository name to store issues
  client_id: xxxx # GitHub Application Client ID
  client_secret: xxxxxx # GitHub Application Client Secret
  admin_user: xyegithub # GitHub repo owner and collaborators, only these guys can initialize gitHub issues
  distraction_free_mode: false # Facebook-like distraction free mode
  # When the official proxy is not available, you can change it to your own proxy address
  proxy: https://cors-anywhere.azm.workers.dev/https://github.com/login/oauth/access_token # This is official proxy address
  # proxy: /login/oauth/access_token
  # Gitalk's display language depends on user's browser or system environment
  # If you want everyone visiting your site to see a uniform language, you can set a force language value
  # Available values: en | es-ES | fr | ru | zh-CN | zh-TW
  language: en
```

`client_id/secret` is your id/secret of `OAuth Apps` in your github.

> A GitHub OAuth App is an application that acts on behalf of the authorizing
> user. It only has access to the user's resources. Removing a user from a
> repository will remove the application access.

`repo` is your github repo name which is used to store the comment data. So you
should create a github repo at first. In my examples it is name with
hexo_comment. `issues` should be enabled for `hexo_comment`.

If your blog is hosted by github. You can just use your blog repo as the repo to
store the comment data.

`distraction_free_mode` should be set into `false`. When set into `true`, the
other part of your blog will get black when one write his comment.

# Baidu/Google Search

Two steps are needed.

1. Add the site to baidu/google, which need a file verifying.
2. Add the sitemap to baidu/google.

To add the sitemap file.

```bash
# add the sitemap plugin which will create sitemap.xml or baidusitemap.xml when hexo d is ran
npm install hexo-generator-sitemap --save
npm install hexo-generator-baidu-sitemap --save
# the original link of each blog is related to the data creating the blog and the name of the blog.
# which is not fixed (once the name of the blog changed.)
# the plugin that fix the link of each blog in the sitemap file.
npm install hexo-abbrlink --save
```

then change the `_config.yml`. This is the Configuration of `hexo-abbrlink`.

```yml
permalink: :year/:month:abbrlink.html
abbrlink:
  alg: crc32 #算法选项：crc16丨crc32
  rep: hex #输出进制：dec为十进制，hex为十六进制
```