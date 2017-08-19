---
title:  "Stars 004 - rotating cube"
---

[Commit 7051262](https://gitlab.com/charlesetc/Stars/tree/7051262a079b50e523421b94e37101ec55a41e33)
implements the Model-View-Projection method to render a rotating cube.

# Rasterization

OpenGL is essentially a very generic way to draw triangles.
This is what "rasterization" means: it's the process of taking
a shape (in this case, a triangle defined by 3 points), and
calculating each pixel it should take up. The cool thing about
modern OpenGL, I think, is that there isn't a direct way to say
`here are triangles; here are their colors; please draw them!`
Instead, you give the GPU some data and a shader program, and say 
`please run this program once for each n bytes of the data`.
The shader program, which is run many times in
parallel, then constructs vertices from this data. You, as
the programmer, write this shader program and dictate how
that data translates into vertices.
Only then does the GPU take the triangles and draw them.

This lets you include arbitrarily complex information in each
vertex: depth, color, or any other input to your shading code.

# Model-View-Projection

MVP is I think how *everyone* does 3D rendering.
In the [last post](/stars-game-3.html), I did have a 3D perspective,
but it was accomplished in a different way:

When rendering the vertices in the shader program, I said the
magnitude of any vertex (the distance away from the origin) should
depend on its depth. (i.e. setting `w` to `z`) This did produce some
sort of strange perspective but the second I tried to rotate the
cube, it skewed in a very strange way.

<video width="600" height="504" controls> <source src="/videos/stars-6.ogv" type='video/ogg; codecs="theora, vorbis"'> </video>

That's supposed to be a rotation around the y axis which is sort of visible but clearly very wrong.

MVP works differently:

* The model - represents the position of the entity you're drawing.
* The view - represents the position of the camera.
* The projection - represents the perspective. (Given where the camera is compared to a triangle, will that triangle be rendered larger or smaller?)

Combine these with matrix multiplication and you're left with one matrix that can be applied to each vertex on the GPU, to determine where on the screen it should fall. And that gives you a cube instead of a square! Want the cube to rotate? Multiply the model by a rotation matrix. This works for the camera too! What would have been a lot of confusing 3D calculations (at least for me), is now one 4-by-4 matrix that is multiplied rapidly in parallel.

<video width="600" height="504" controls> <source src="/videos/stars-5.ogv" type='video/ogg; codecs="theora, vorbis"'> </video>

And that's all I know about cube-making! My next objective is to render a more complicated 3D model by parsing a `.obj` file.
