---
title: "Fuzzy find your $PATH"
date: "2018-12-17"
---

So I've been fzf'ing things again.

![eye-roll](/images/hmmm.gif)
<br/>

[Fzf](https://github.com/junegunn/fzf) is an tool that lets you search through lines of text interactively. My most common use-cases are fuzzy-finding all files in the current directory and its children, and fuzzy-finding through my shell history.

Fzf saves you from typing out long, exact pieces of text when there's a
relatively small search space of things you might want to type.  It occurred to me recently that the executables your $PATH (cat, grep, basename, etc) are things that we type all the time, with a very small, easily-identifiable search space.


You can see almost what it looks like by running `compgen -c | fzf` in bash or
`whence -pm '*' | fzf` in zsh.

So I made some keybindings! The code is mostly copied from the official fzf
keybindings.

For zsh, add this to your `.zshrc`
```zsh
fzf-binary-widget() {
  selected=( $( whence -pm '*' | \
    xargs -IX basename X | \
    FZF_DEFAULT_OPTS="--height \
    ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS \
    -n2..,.. --tiebreak=index \
    --bind=ctrl-r:toggle-sort \
    $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} \
      +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    LBUFFER="${RBUFFER}$selected "
  fi
  zle redisplay
  return "$ret"
}
zle     -N   fzf-binary-widget
# bind to Control-h, change this if you want a different key
bindkey '^H' fzf-binary-widget
```

For bash, add this to your `.bashrc`
```bash
function __fzf_binary__() {
  local selected="$(compgen -c\
    | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-80%}\
    --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@")"
  READLINE_LINE="\
  ${READLINE_LINE:0:$READLINE_POINT}\
  $selected${READLINE_LINE:$READLINE_POINT}"
  echo -ne "$selected"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}
# bind to Control-h, change this if you want a different key
bind '"\C-h": " \C-e\C-u\C-y\ey\C-u`__fzf_binary__`\e\C-e\er\e^"'
# Required to refresh the prompt after fzf
bind '"\er": redraw-current-line'
bind '"\e^": history-expand-line'
```

Most of this was copied from the official Fzf keybindings, so I can't
explain much. `whence` and `compgen` list available binaries in zsh and bash respectively.

Then you can hit Control-H to fuzzy-find your path!

![done with that](/images/done-with-that.gif)
