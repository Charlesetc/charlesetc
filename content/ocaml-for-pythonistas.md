---
title: "OCaml for Pythonistas"
date: "2018-03-30"
draft: true
---

So you like Python and you want to write something performant!

Exciting! Sounds like you've got a fun project ahead of you.
You've got a couple of options. Depending on what kind of
project you're working on, you might want to try:

* Using [PyPy](https://pypy.org/), a just-in-time compiler for Python.

* Doing extensive profiling, and writing the most commonly used parts in C.

This definitely leaves something to be desired. PyPy is only suitable for applications
where the added warm-up time is negligible, and it's less well-supported than CPython (the normal Python interpreter). And writing C is unsafe and defeats the point of choosing an elegant language like Python in the first place.

(I guess you could also use [Cython](http://cython.org/) for your C-extension; this might actually be a great solution too.)

But you also might enjoy looking into OCaml!
OCaml is _**fast**_ and _**clean**_ —
just as clean as Python if you can believe it

But *how you even do things in OCaml*?
Let's find out!

# Guess the Number

```python
import random

def guess_a_number():
  number = random.randint(1, 100)
  def wrapper(guess):
    if guess < number:
      print("lower")
    elif guess > number:
      print("higher")
    else:
      print("you got it!")
  return wrapper

guess = guess_a_number()
guess(45)
guess(33)
guess(37)

```

```ocaml
let guess_a_number () =
  let number = Random.int 100 in
  fun guess ->
    print_endline
      if guess < number then "lower"
      else if guess > number then "higher"
      else "you got it!"

let guess = guess_a_number () in
guess 45;
guess 33;
guess 37
```

