---
title:  "Stars 002"
---

I doubt I will post every day, but this is a summary of the progress
([commit dfe0df2](https://gitlab.com/charlesetc/Stars/tree/dfe0df2e43aa14676d8c635eb802f25401912fc3))
made so far:

<video width="600" height="504" controls> <source src="/videos/stars-3.ogv" type='video/ogg; codecs="theora, vorbis"'> </video>

It turns out rendering two objects is a *lot* harder than rendering one. You have to switch to a different context (vertex buffer)
each time you draw a shape.

I also converted the while-loop design of the game to an async [pony](https://www.ponylang.org/discover/) behaviour that repeatedly calls itself. This lets the garbage collector run in between renderings and the game run on multiple cores.


# Blender

Lastly, I went from zero knowledge of blender to the following, taught by the talented daughter
of the family I'm staying with!

<video width="600" height="398" controls> <source src="/videos/stars-2.ogv" type='video/ogg; codecs="theora, vorbis"'> </video>

My goal is to parse the `.obj` file that blender can export and then render it within
`Stars`. Hopefully, this will allow for complicated characters and animations.

The most immediate step, however, is to render and shade a cube. Fingers crossed for tomorrow!

### Stars posts and adventures:

<div class="table-of-contents">
* _Aug 15, 2017_ - [Take-off](stars-game-1.html)
* _Aug 16, 2017_ - [Stars 002](stars-game-2.html)
</div>

