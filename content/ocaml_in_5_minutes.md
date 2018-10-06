---
title: "OCaml in 5 minutes"
date: 2018-08-12T20:18:22-04:00
---

I think OCaml is a great language. This will teach you enough to start
coding in it. Not enough to understand other people's OCaml, not enough to say
you know most of OCaml, but just enough to start actually writing your own
code and reaping OCaml's benefits!

# Development environment

Vim, Emacs, Atom, VSCode, whatever. OCaml has great editor integration,
but we only have 5 minutes. When you have more time, check out
[merlin](https://github.com/ocaml/merlin). For now, so long as you're using
a file ending in `.ml`, you're doing it right.

# Install OCaml

Again, 5 minutes, so let's keep this brief:

```bash
$ wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin

$ opam init -y --compiler=4.06.1

$ eval `opam config env`

$ opam install -y utop ocamlbuild  # a repl and a build system, respectively
```

(taken from the [opam installation
guide](https://opam.ocaml.org/doc/Install.html) and [Jane Street's
guide](https://github.com/janestreet/install-ocaml))

# Write OCaml

Okay now it's time to learn some OCaml! Luckily we're only going to learn
5 concepts!

## Concept 1: Constants

```ocaml
"hi there"                : string
2.4                       : float
[2; 3; 4]                 : int list
[[true, false], [true]]   : bool list list
()                        : unit
(2, "okay")               : int * string
(* yeah, tuples are weird. *)
(* also, this is a comment. who knew! *)
```

The `:` is a type assertion. Types are on the right. Think that was
7 concepts? Too bad we have to move on!

## Concept 2: Functions!

OCaml doesn't use parenthesis for function calls, they are separated from
their arguments by spaces.

```ocaml
print_endline "Hi there"
```

Function definitions?

```ocaml
let rec repeat s n =
  if n = 0
  then ""
  else s ^ repeat s (n - 1)
```

Whoops learned `if` by accident. `^` is string concatenation. `let rec`
means this function is recursive. Just use `let` if you're not writing
a recursive function.

```ocaml
print_endline (repeat "Let it snow, " 3)
```

This prints `Let it snow, Let it snow, Let it snow, `. Next!

## Concept 3: Custom datatypes.

```ocaml
type only_apple = Apple of { color : string
                          ; sweetness : int }

let best_apple_ever = Apple { color = "red"; sweetness = 10000 }

(* how do you get the sweetness of an Apple?
   why, pattern match against it! *)
let what_was_the_sweetness_again =
  match best_apple_ever with
  | Apple { sweetness ; _ } -> sweetness

(* actually let's have more kinds of fruit *)

type fruit = Pear of { color : string
                     ; sweetness : int }
           | Grapes of int
           (* This one doesn't carry data,
              apart from being a banana *)
           | Banana

let best_pear_ever = Pear { color = "green"; sweetness = 5 }

let what_was_the_sweetness_again =
  match best_pear_ever with
  | Pear { sweetness ; _ } -> sweetness
  | Grapes _
  | Banana ->
    raise (Failure "can't find out the
           sweetness of grapes or bananas")
```

There are other ways to define datatypes in OCaml! Search for
"Structures", "GADT's", "Polymorphic Variants", and "Objects" if you want.
That said, you should be able to write most things with these normal
variants we have here.

## Concept 4: Bingings & mutable variables

So up until now we've only actually seen top-level bindings.  Say you're
defining a function and you want to make a new binding, you must use `let
... in`:

```ocaml
let to_the_fourth x =
  let x_squared = x * x in
  x_squared * x_squared
```

Aaand let's also learn how to make mutable references:

```ocaml
(* top-level statement that moves from using
   the top-level let syntax to the
   expression-level let syntax... :/
   i.e `let ... in`, instead of just `let`
   *)
let () =

  let i = ref 0 in
  while i <= 10 do
    print_endline (string_of_int !i);
    i := !i + 1
  done
```

So `ref` creates a mutable reference, given an initial value. `!` gets the
value of a reference when it's executed, and `:=` updates a reference to
a new value. Also `;` chains statements together!

## Concept 5: Modules

There's a whole bunch of language features that happen at the module level. Here's what you need to get started:

1. Every file defines a module. "fire.ml" will create a "Fire" module. All modules are capitalized.
2. Use `module Your_module_name = struct ... end` to define a module within a module.
3. Use `String.sub` gets the function `sub` from the `String` module.
4. A common idiom is to have a `type t` in a module. For example `Queue.t`
   would be a queue, and `Hashtbl.t` would be a hashtable.


Here's an example using the `Queue` module from the standard library:

```ocaml
let () =
  let q = Queue.create () in
  Queue.add "hi" q;
  Queue.add "you" q;
  print_endline (Queue.pop q);
  print_endline (Queue.pop q)

  (* it'll print "hi" and then "you" *)
```

# Running OCaml

Okay! You made it! Congrats!

So if you run `utop` in your shell, it should open an OCaml repl that you
can experiment with.

Alternatively, write some OCaml code to `your_module.ml` and then, in the
same directory, run `ocamlbuild your_module.byte`. This will give you an
executable `./your_module.byte`.

# Recap

So you now know about OCaml's

* constants,
* functions,
* datatypes,
* bindings & references,
* and modules.

And you know how to run your code! This leaves out **a whole lot**, but  [The
Standard Library](https://caml.inria.fr/pub/docs/manual-ocaml/stdlib.html)
reference is useful to have, as is [The OCaml
manual](https://caml.inria.fr/pub/docs/manual-ocaml/index.html). Also [Real
World OCaml](https://v1.realworldocaml.org/) is great learning material for the
rest of OCaml.

