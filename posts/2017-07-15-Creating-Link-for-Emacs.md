---
title: Creating Link for Emacs
author: Ryan Desfosses
---

I have a [local config repo](https://github.com/rdesfo/myConfig) that contains my settings for my laptop
and my most used applications, which includes emacs.  Emacs uses
`myinit.org` file to download and configure modules to manage my
ever evolving setup.

The way I've been managing this is by copying the org-file from `.emac.d`
folder to my `myCofig` git repo.  This is kinda silly.  So to fix this I just
moved the file to the git repo and created a symbolic link to its new home.

    mv myinit.org ~/src/myConfig/
    ln -s /home/ryan/src/myConfig/myinit.org myinit.org

Once this was done I verify the link was pointing to the correct file.

    ls -ltra

Once this was complete, I opened emacs and saw the following prompt:

    Symbolic link to Git-controlled source file; follow link? (y or n)

After selecting yes, emacs opened with the correct configuration. (yay!)

Now that emacs was working correctly I wanted to avoid the prompt and just have
emacs follow the sym link.  After a quick search on the inter-webs&#x2026;
[stackoverflow](https://stackoverflow.com/questions/15390178/emacs-and-symbolic-links) provided me with what I was looking for.  I just needed to add

    (setq vc-follow-symlinks t)


to the `myinit.org` file that I moved and log in one more time to sync up the settings.
Now I can manage my emacs setting properly with git.
