---
title: "Gui development is broken."
date: 2018-04-15T00:35:35-05:00
draft: true
---

This afternoon I sat down to write a mini text editor.
I wanted something reasonably fast, with a simple way of
producing graphics. And I wanted to do it in OCaml. Here's
what I found.

# Option 1: The Web

By far the most widely used graphics toolkit in history is
HTML and CSS. It comes with it's own scripting language, and
tens of thousands of developers willing to lend support.
Hundreds of companies solely exist to make it easier to make
websites.

And it's definitely the easiest option. God, CSS is so easy.
It's the first thing I learned as a programmer and it's
ridiculous how much better designed, better documented, and
better implemented it is than the alternatives I tried later.

But it turns out all that power comes at some cost! It takes
a lot of code to render a complex webpage, and it's not the
most performant situation. Atom has been criticized a lot for
being slow and at least part of that is probably due to it's
reliance on javascript and the DOM.

All in all, I decided I didn't want to write or compile to
javascript and I didn't want to have a browser as a dependency
for my text editor. (I want to make something that can open
a new window quickly.)

What other GUI options did I have?

# Option 2: The Terminal

Okay, simple. You want to make a text editor, make it like vim
or nano. That's got to be easy, right?

Terminals communicate with their program through a text-based
protocol and allow everything from mouse input to colorful
ascii-based animation.

It's "simple", see, the program just outputs text and that
text is rendered on the screen. *Except* if one of those
pieces of text happens to start with `\[\033]0;`, in which
case any number of things could happen... from changing the
title of the terminal window, to **requesting the mouse's
current location**.  But thankfully you wouldn't have to do
stuff like that much... unless you're writing a text editor.

The problem here is that this isn't a graphics-free solution.
I'd still building a graphical program, albeit a very
text-based one. And the protocol for making these graphics is
outdated and poorly designed. And it's about the only graphics
API that doesn't have a rectangle primitive. We can do better.

Plus, I'd still have to choose a terminal emulator. Very few
people program just within the linux console, without the
X server running. And terminals are **not** simple pieces of
software. Xterm is over 65 thousand lines of code. Even
[suckless's terminal](https://git.suckless.org/st/tree/st.c)
is 2619 lines of code. So that's fine, I guess, it's going to
take the code it's going to take, but why so complex? *Oh
right,* terminals use an archaic textual interface to render
a program graphically.

Still don't think that terminals expose a graphical interface?
Consider [alacritty](https://github.com/jwilm/alacritty),
a terminal that uses the GPU to accelerate this rendering
process.

You can definitely make a case for terminals and they have
their place, but I don't think calling them broken for
anything more interactive than `ed` is at all a longshot.

# Option 4: Writing to the framebuffer

I only considered this because of [a really interesting
blogpost](http://seenaburns.com/2018/04/04/writing-to-the-framebuffer/)
that outlines writing to the framebuffer.

Writing pixels directly to the screen is as low-level as I can
imagine and I whole-heartedly support any courageous soul who
attempts to write a text editor this way. I'm not sure how
user-input would work; maybe reading directly from a keyboard?

One huge disadvantage, aside from the myriad of clear ones, is
that it doesn't fit within a window manager. You can't have
different workspaces or alt-tab or anything. Alas! It was
a fun thought.

# Option 5: the X server

Ah the X server! Well known for being kind and gentle. I'll be
honest, I don't know how the X server works or what its
protocol looks like. I tried using several different OCaml
bindings to Xlib, which is the main C interface to the
X server.

These worked with varying degrees of success. It certainly
took more than a few lines of HTML and CSS to get some
stylized text. My largest issue is that any textual
display supported by X11 is restricted to bitmap fonts. (Fonts
that cannot be scaled up or down; each pixel is determined by
the font.)

This was kind of a deal-breaker for me, since I have
a high-dpi screen bitmapped fonts look pretty small on it.
I briefly considered making my own bitmap font before taking
a look into how most applications use modern, scalable fonts.

There is a library called "FreeType" that turns vector glyphs
into pixels. You can combine this with a low-level X11
interface to create the whole glyph set and then try to draw
each glyph in the right spot. I'd much rather have something
do that for me. So I looked into
[Cairo](https://cairographics.org/), an image drawing library
which calls FreeType and supports writing to the X server.

The problem is the OCaml Cairo library supports almost all of
Cairo's targets *except* X11. I spent some time trying to
implement the bindings myself, had a good time, but ultimately
decided to try further up the stack.

# Option 6: A GUI library

> "Why," you say, "there are plenty of libraries designed just
for this purpose! GUI libraries!"

Yes. But GUI libraries are all designed with C bindings, none
of which are particularly well supported in OCaml. The best
set of bindings [LablGTK](http://lablgtk.forge.ocamlcore.org/)
are for GTK 2, last updated in 2013.

LablGTK is actually quite impressive. I believe it's the most
extensive use of OCaml objects in history. OCaml's objects were the result of a
2002 [research
paper](https://caml.inria.fr/pub/papers/garrigue-structural_poly-fool02.pdf)
in type inference. LablGTK provided the first safely-typed
interface to the highly dynamic GTK API, but it's not quite
what I'm looking for.

Want to make a GUI with lots of buttons, text boxes, and radio
buttons? Then GTK is perfect. (GTK 3 even supports CSS, but
alas LablGTK is GTK 2.) But I need fine control over
everything in the text area. That's not to say it's not
possible with GTK. It would just be too complex and the OCaml
bindings are too poorly documented for me to want to continue
down that road.

# What are we missing?

Why is this so hard? I just want low-level access to simple
graphics primitives in a somewhat obscure language.

> Okay maybe I get why it's hard.

But seriously, we've made lots of language-independent
systems, why can't this be one? Tons of people must want
language-agnostic graphics primitives!

I think GUI libraries, especially, are going down the wrong
path. Yes, they've accomplished a lot and if you want to write
a complex GUI you can pick up python and one of its many GUI
toolkits, or C and one of it's many GUI toolkits, and actually
do it.

But they all expose a C interface and let each programming
language figure it out for themselves. Consider, for a moment,
how much better terminals are, conceptually. **Any** program
in **any** language can just output the right escape
characters and make an interactive, somewhat graphical
program. A protocol for expressing what should be displayed is
wayyy better than a series of C calls that must be made in
a particular order.

<span class="scream">We need this for high level graphics.
Please!</span>


Imagine, if you will, a procedural, json-based interface to
the screen. Run with the fictive command `graphical python
example.py`

```ruby
import json

def out(a): print(json.dumps(a))
def get(): json.parse(input())

out({command: "new_window",
     background: "black",
     title: "example!"})

window_id = get()

out({command: "new_text_box",
     border: "grey",
     content: "hi there!"})

text_box = get()

out({add: text_box, to: window_id})

out({command: "pop_event_queue"})

event = get() # etc...
```

I don't care about the particulars. Maybe not stdin and
stdout. Maybe it communicates with the graphical process over
sockets. Point is, I want something simpler and higher-level
than X11, with a json protocol.

---

Imagine the advantages.

1. Any language can speak json fluently.
4. It's lower level and faster than manipulating a DOM.
2. Unit testing for graphics commands is suddenly easy.
3. You get readable and searchable json for debugging.

---


Graphical user interfaces are truly awesome. In fact, they're
so awesome we don't do anything without them. Let's make them
awesome to write.

<span class="postscript">PS. Now I really want to write GUIs
with [jq]( https://stedolan.github.io/jq ).</span>
