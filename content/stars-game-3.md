---
title:  "Stars 003"
date: "2017-08-17 12:14:30 -0700"
---

With the release of
[commit 2eeedf9](https://gitlab.com/charlesetc/Stars/tree/2eeedf9c916958eee5d6aeeb0dbb0f94570fb17c)
there is now a three dimensional cube!

<video width="600" height="504" controls> <source src="/videos/stars-4.ogv" type='video/ogg; codecs="theora, vorbis"'> </video>

The hard part here wasn't actually putting the vertices in 3 dimensions —
the OpenGL API is set up for 3 dimensions already —
the difficulty was getting each triangle and pixel to render
at the right depth, and in the right order.

It's pretty exciting because the rainbow triangle is actually 'drawn' after
the cube, but the cube shows up on top. The GPU does a second pass after
rendering all of the vertices and fragments to decide how they overlap.

I also spent a fair amount of time today trying to get the cube to rotate.
This is done by giving the cube a rotation matrix which you change a bit after each render.
It looks very strange at the moment because I think I'm rotating around the origin, whereas
a spinning cube should rotate around its center.

Anyway I have two goals for the upcoming days:

1. Rotate the cube.
2. Light the cube so that the faces get darker or lighter as it rotates.
