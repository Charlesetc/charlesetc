---
title:  "Stars 006 - dark teapot"
date: "2017-08-23 12:14:30 -0700"
---

Not only does [commit 91b838a](https://gitlab.com/charlesetc/Stars/tree/91b838a82c39f56c0181703a214c731285105c94)
bring a completely rendered monkey, there's now shading and teapots!

<video width="600" height="504" autoplay loop> <source src="/videos/stars-8.ogv" type='video/ogg; codecs="theora, vorbis"'> </video>

Each vertex of the model should come with a normal, which represents
the angle the surface is facing, at that vertex.
The shading itself isn't very hard once you've loaded the normals.

The amount of shadow is calculated by combining the direction of the sunlight and the vertex' normal.

What took me *way too long* to get here was a bug loading the `.obj` file.
It turns out `.obj` files specify their faces using 1-indexing. **1-indexing!**
So the code change to go from a completely broken state to a working state only took subtracting one in one place and several hours of frustration.

Anyways, here's what the inside of a monkey looks like:

<video width="600" height="504" controls> <source src="/videos/stars-9.ogv" type='video/ogg; codecs="theora, vorbis"'> </video>

And this is the monkey, properly shaded, from the outside:

<video width="600" height="504" controls> <source src="/videos/stars-10.ogv" type='video/ogg; codecs="theora, vorbis"'> </video>

The next step is to try to implement cel-shading, which gives a cartoon-like impression, using only several shades for each shadow:

![](/images/700px-Celshading_teapot_large.png)
