---
title:  "Stars 005 - lopsided monkey"
---

I now have a half-complete monkey being rendered. ([Commit f1f6b15](https://gitlab.com/charlesetc/Stars/tree/f1f6b152d09d5601525dd908af3a4e46bf29f659))

<video width="600" height="504" controls> <source src="/videos/stars-7.ogv" type='video/ogg; codecs="theora, vorbis"'> </video>

Note the very problematic right side!

I think this is happening because either a vertex is
incorrectly inserted or a vertex is lost somewhere along the line.

I'm parsing what's called a `.obj` file — an ASCII text format
for representing 3D objects. Here's an `obj` representation of
a cube:
```bash
mtllib cube.mtl
o Cube
v 1.000000 -1.000000 -1.000000
v 1.000000 -1.000000 1.000000
v -1.000000 -1.000000 1.000000
v -1.000000 -1.000000 -1.000000
v 1.000000 1.000000 -0.999999
v 0.999999 1.000000 1.000001
v -1.000000 1.000000 1.000000
v -1.000000 1.000000 -1.000000
vn 0.000000 -1.000000 0.000000
vn 0.000000 1.000000 0.000000
vn 1.000000 0.000000 0.000000
vn -0.000000 -0.000000 1.000000
vn -1.000000 -0.000000 -0.000000
vn 0.000000 0.000000 -1.000000
usemtl Material
s off
f 1//1 2//1 3//1 4//1
f 5//2 8//2 7//2 6//2
f 1//3 5//3 6//3 2//3
f 2//4 6//4 7//4 3//4
f 3//5 7//5 8//5 4//5
f 5//6 1//6 4//6 8//6
```

It's really simple — `v` loads a vertex, `vn` loads a vertex normal, and `f` loads a face (i.e. triangle).

The color of the monkey currently signifies the normals that have be loaded. You can kind of see
how the color changes almost continuously depending on the orientation of the vertex. (Excluding the
right side of course.) These normals will be used for lighting and shading the monkey, which is what
I plan to implement soon.

Right after I fix this blasted vertex bug!
