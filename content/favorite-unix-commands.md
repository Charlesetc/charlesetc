---
title: "My Favorite Unix Commands"
date: 2018-04-26T22:42:15-05:00
---

This list is as much for me as for anyone else but I hope
it'll be useful to all parties in the future!

* [rlwrap](https://github.com/hanslub43/rlwrap) — turn any
  repl into one that supports arrow keys and control-r to
  search through history.
* [fzf](https://github.com/junegunn/fzf) — fuzzy find
  anything.
* [lp](https://www.cups.org/doc/options.html) — print from the
  command line.
* [tree](https://en.wikipedia.org/wiki/Tree_(Unix)) — pretty
  prints an entire directory.
* [xclip](https://github.com/astrand/xclip) — pipe into your
  clipboard.
* [j](https://github.com/wting/autojump) — jump around instead
  of cd-ing.
* [entr](http://entrproject.org/) — run a command when a file
  changes.
* [zathura](https://pwmt.org/projects/zathura/) — miles ahead
  of any other pdf viewer I've ever used. Live reload
  alongside with keyboard navigation.
* [locate](https://en.wikipedia.org/wiki/Locate_(Unix)) — find
  files all over your hard drive quickly.
* [scrot](https://en.wikipedia.org/wiki/Scrot) — good for
  capturing screenshots.
* [rg](https://github.com/BurntSushi/ripgrep) — I've also used
  [ag](https://geoff.greer.fm/ag/) for a long time quite
  happily.
* [ruby](https://www.ruby-lang.org/en/) — pretty obscure
  scripting language you might want to check out.
* [jq](https://stedolan.github.io/jq/manual/) — awesome
  language for manipulating json.
* **whitespace**  (alias) recursively removes whitespace.
  `whitespace="find -type f -exec sed -i 's/ *$//' {} +"`
* **static**  (alias) statically serve files in current
  directory `alias static='ruby -run -e httpd . -p 9000'`
