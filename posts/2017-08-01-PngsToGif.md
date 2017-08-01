---
title: Portable Network Graphics To Graphics Interchange Format
author: Ryan Desfosses
---

I recently had a pitch accepted for [fedora magazine](https://fedoramagazine.org) and as I was putting the article together
I wanted some images to liven up the piece a bit.  I decided to attempt to reuse images
from the application's website, but there were a couple of hurdles I had to get over to use them.

First, the images were taken on another distro, so I felt like it would be appropriate to crop that
out.  Second, the images were provided in a `png` format and I wanted a `gif`.

## Download Images

The first leg of my `gif` journey required me to get the images I wanted to work with&#x2026; simple enough.
The commands below are what I used.

    mkdir /tmp/ring_images
    curl https://ring.cx/sites/ring.cx/files/1_welcome_screen_0.png -o /tmp/ring_images/1_welcome_screen_0.png
    curl https://ring.cx/sites/ring.cx/files/2_register_username.png -o /tmp/ring_images/2_register_username.png
    curl https://ring.cx/sites/ring.cx/files/3_ringid_qr_code_0.png -o /tmp/ring_images/3_ringid.png
    ls /tmp/ring_images

## Format

Originally, I just edited the images in [shotwell](https://wiki.gnome.org/Apps/Shotwell),
but I wanted the process to be reproducible in the future.
So, I decided to look up [imagemagick](http://www.imagemagick.org).
The code below iterates through pictures downloaded in the previous step and crops the undesired bits. 

    for i in $( ls /tmp/ring_images/ ); do
      convert /tmp/ring_images/$i -crop 3050x1710+150+90 +repage /tmp/ring_images/$i
    done

A couple notes about the command above.  The format of the `crop` option takes the
`<width>x<height>+<x offset>+<y offset>` and `repage` option resets the virtual canvas.
This is necessary to avoid blank spaces that appear on the edges of the images
(as result from the cropping).

## Create gif

Now that the images are formatted to my liking I just had to glue them together into a single gif.
This was done with the following.

    convert -size 600x600 -delay 300 -loop 0 /tmp/ring_images/*.png /tmp/output.gif

The `delay` option specifies the number of ticks each image will show for in the gif.
Since I set it to 300 and the default ticks per second is 100, each image should show for 3 seconds.
To set the gif to repeat infinitely `loop` was set to zero.


## Final Thoughts

The scripts above will still need to be updated to use for other projects in the future,
but they still produce a usable `gif` and the structure of the code is still there.
Most importantly it was fun putting it together and learning more about such a dynamic tool
like [imagemagick](http://www.imagemagick.org).

