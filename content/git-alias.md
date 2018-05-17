---
title: "Git Aliases"
date: 2018-05-16T21:39:00-05:00
draft: true
---

I've just created two new git aliases that
allow me to do things like

```bash
git hub ocaml/ocaml
```

and

```bash
git lab charlesetc/dotfiles
```

to clone the respective repositories.

It's a bit easier than typing out `git clone git@github.com:ocaml/ocaml` and much more fun :)

These lines in your `~/.gitconfig` should get this working.

```haskell
[alias]
hub = "!f() { git clone git@github.com:$1; }; f"
lab = "!f() { git clone git@gitlab.com:$1; }; f"
```

