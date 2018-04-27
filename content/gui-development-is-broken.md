---
title: "Gui development is broken."
date: 2018-04-17T00:35:35-05:00
---

This afternoon I sat down to write a mini text editor.

* I wanted something reasonably fast, with a simple way of
  producing graphics.

* I wanted to draw a horizontal line between the name of the
  file and its contents.

* I wanted to be able to open new instances/windows of this
  text editor quickly to fit into my workflow.

* And I wanted low-level control of how the text was rendered
  (fonts, syntax highlighting, and the ability to add vim
  keybindings.)

* I wanted this to be *easy*.

And I wanted to do it in OCaml. Here's what I found.

# Option 1: The Web

By far the most widely used graphics toolkit in history is
HTML and CSS. It comes with its own scripting language, and
tens of thousands of developers willing to lend support.
Hundreds of companies exist solely to make it easier to make
websites.

And it's definitely the easiest option. It's the first thing
I learned as a programmer and it's ridiculous how much better
designed, documented, and implemented it is than all the
alternatives I tried later.

But it turns out that all that power comes at some cost! It
takes an enormously complex browser to render a webpage, and
it's not the most efficient situation. Atom has been widely
criticized for being slow, in part due to its reliance on
javascript and the DOM.

All in all, I decided I didn't want to write or compile to
javascript, and I didn't want to have a browser as
a dependency for my text editor. (I wouldn't have been able to
open new instances of the editor quickly.)

What other GUI options did I have?

# Option 2: Writing to the framebuffer

I only considered this because of [a really interesting
blogpost](http://seenaburns.com/2018/04/04/writing-to-the-framebuffer/)
that outlines writing to the framebuffer.

This strategy, writing pixels directly to the screen,
is as low-level as I can imagine and I whole-heartedly support
any courageous soul who attempts to write a text editor this
way. I'm not sure how user-input would work; maybe reading
directly from a keyboard?

One huge disadvantage to this option is that it doesn't fit
within a window manager. I wouldn't be able to use different
workspaces or alt-tab or anything. Alas! It was a fun thought.

# Option 3: The Terminal

Okay, simple. You want to make a text editor, make it like vim
or nano and run it in a terminal. That's got to be easy,
right?

Wrong.

Terminals communicate with their program through a text-based
protocol and most allow everything from mouse input to
colorful ascii-based animation. Specifically, terminals do
a lot more than just printing text. (Refer to [this fantastic
talk](https://www.youtube.com/watch?v=rSnMoClPH2E) that goes
into ANSI terminals in much more depth.)

The protocol is "simple", see, the program just outputs text
and that text is rendered on the screen. *Except* if one of
those pieces of text happens to look like `\[033\[3;9H]` or
like `/x1b[31m`, in which case any number of things could
happen... from changing the title of the terminal window, to
**requesting the mouse's current location**.  But thankfully
you wouldn't have to do much stuff like that... unless you're
writing a text editor.

Plus, I'd still have to choose a terminal emulator. And
terminals are **not** simple pieces of software. Xterm is over
65 thousand lines of code. Even [suckless's
terminal](https://git.suckless.org/st/tree/st.c) is 2619 lines
of code. Why so complex? *Oh right,* terminals use an archaic
textual interface to render a program graphically.

Still don't think that terminals expose a graphical interface?
Consider [alacritty](https://github.com/jwilm/alacritty),
a terminal that uses the GPU to accelerate this rendering
process.

You can definitely make a case for terminals and they have
their place, but I don't think calling them broken for
anything more interactive than `ed` is at all a longshot. And
writing an interactive terminal-based text editor, even
a simple one, would not be easy.

# Option 4: the X server

Ah the X server! (Well known for being kind and gentle.) I'll be
honest, I don't know how the X server works or what its
protocol looks like. I tried using several different OCaml
bindings to Xlib, which is the main C interface to the
X server.

These worked with varying degrees of success. It certainly
took more than a few lines of HTML and CSS to display some
colourful text. My largest issue is that any textual display
supported by X11 is restricted to bitmap fonts. (Fonts that
cannot be scaled up or down; each pixel is determined by the
font.)

Since I have a high resolution screen, this was kind of
a deal-breaker for me. Bitmapped fonts look pretty small on
it. I briefly considered making my own bitmap font before
taking a look into how most applications use modern, scalable
fonts.

There is a library called "FreeType" that turns vector glyphs
into pixels. This can be combined with a bare-bones X11
interface to create the whole glyph set and then try to draw
each glyph in the right spot. I'd much rather have something
do that for me...

# Option 5: A Drawing toolkit!

Yes! There's a toolkit for making drawings
[Cairo](https://cairographics.org/), more abstract than the
X server, but less complicated than most GUI libraries. Cairo
calls FreeType itself to render text, and gives you all the
drawing primitives I would need. This works pretty well! And
is probably what I will end up using. :D

But let's say you also want a button.

A button?

Yeah, a button. Or a scrollbar. Or, dare I say, a drop-down
menu? A drawing toolkit aint gonna work for long.


# Option 6: A GUI library

> "Why," you say, "no need to speak to the X-server directly
> — there are plenty of libraries designed for just this
> purpose! GUI libraries!"

Yes! The best set of bindings in OCaml are
[LablGTK](http://lablgtk.forge.ocamlcore.org/) for GTK 2.

LablGTK is actually quite impressive. I believe it's the most
extensive use of OCaml objects in history. OCaml's objects were the result of a
2002 [research
paper](https://caml.inria.fr/pub/papers/garrigue-structural_poly-fool02.pdf)
on type inference. LablGTK provided a safely-typed interface
to the highly dynamic GTK API.

But GTK is so complicated! It's great when you want to make
something like Gimp, but if you just want a few buttons and
some text, using GTK is like mowing a lawn with a helicopter.

And I got lucky that OCaml had this great set of bindings.
What if I wanted to write a GUI in an *even more* obscure
language? What, I've just got to link to C libraries and write
the bindings myself? This seems a bit ridiculous.

# What are we missing?

Why is this so hard? I just want low-level access to write
a **simple** graphical interface in a somewhat obscure
language.

> Okay maybe I get why it's hard.

But seriously, we've made lots of language-independent
systems; why can't this be one? Tons of people must want
language-agnostic graphics interfaces!

I think GUI libraries are going down the wrong path. That's
not to say they don't have a place, but they only expose
a C interface. This leaves each programming language to figure
out its own bindings, resulting in poor support and incomplete
documentation.

<span class="scream">We can do better:</span>

Imagine, if you will, a procedural json interface to the
screen. Run with the fictitious command `graphical python
example.py`

(This is similar to the web, really, but it's procedural
instead of declarative, and the scripting is done
server-side.)

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

out({command: "draw_triangle",
     color: "pink",
     coordinates: ... })

out({command: "pop_event_queue"})

event = get() # respond to event...
```

I don't care about the particulars. Maybe not stdin and
stdout. Maybe it communicates with the graphical process over
sockets. Point is, I want something simpler and higher-level
than X11, with a json protocol.

---

Imagine the advantages.

1. All languages speak json fluently.
2. One set of documentation for all languages.
3. It would be lower-level and faster than manipulating a DOM,
   without the need for a browser.
4. **Unit testing for graphical commands** would suddenly be
   easy.
5. You'd get readable and searchable json for debugging.

---

Graphical user interfaces are truly awesome. They're
so awesome we don't do anything without them. Let's make them
easy and fun to write.

<p class="postscript"> PS. Now I really want to write GUIs
with <a href="https://stedolan.github.io/jq">jq</a>.
<br/>
Thanks to Laura Lindsey, Paul Gowder, Tom Ballinger, Tobin
Yehle, and Kevin Lynagh for their feedback on this post!
</p>
