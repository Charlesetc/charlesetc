---
layout: post

title: "& disown"

date: "2017-06-10 08:14:30 -0700"

categories: bash

---

I've often wanted to start a subprocess as a daemon in bash or zsh.

Now I know how!

```bash
the_command & disown
```

You will still see stdout and stderr in the terminal, but you can
exit from the shell process without killing the command.

```bash
nohup the_command
```

`nohup` also works, but will send the stdout to a file instead of your
terminal.

If you want to do this to a running process,
you can `<C-z>`, run `bg`, and then `disown %1`.
