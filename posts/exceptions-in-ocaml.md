---
layout: post

title: "Exceptions in Reason (OCaml)"

date: "2016-06-22 02:00:42 -0400"
categories: ocaml
---

# Pattern Matching

A large part of function programming is pattern matching:

```rust
/* A new and delicious enum */
type fruit = Apple | Pear | Pineapple | Orange;

let my_fruit = Pear;

/* print the outcome of the switch statement */
print_string (switch my_fruit {
  | Apple => "you have an apple"
  | Pear => "you have a pear"
  | _ => "you have neither an apple or a pear"
});
```

# Except...

The cool part is how Reason handles exceptions: as another branch in
a switch statement.

```rust
exception My_exception;

/*
 * Here's a function that occasionally throws an exception
 */
let risky_function => switch (Random.int 3) {
  | 0 => true
  | 1 => false
  | 2 => raise My_exception
};

/*
 * We can match against the possible cases of risky_function,
 * even exceptions.
 */
switch (risky_function ()) {
  | true => "handling true"
  | false => "handling false"
  | exception My_exception => "handling my exception"
};
```

Throwing an exception is different than returning something - an exception unwinds the stack until
it's caught.

Exceptions don't have to be used just for error scenarios.
They are called "exceptions" after all - they are meant to propose an exceptional **case**.

Reason does a nice job of accepting this control flow mechanism as a case
in a switch statement, whereas it looks very hacky in languages using
try-catch.

#### Python

```python
def read_first_line(filename):
  f = open(filename, "r")
  return f.readline()

try:
  line = read_first_line("file.txt")
  if line == "hi":
    message= "You said 'hi'!"
  else:
    print "You didn't say hi :("
except IOError:
  print "error reading your salutation"
  
```

#### Reason

```rust
let read_first_line filename => {
  let f = open_in filename;
  input_line f
};

print_string (switch (read_first_line "file.txt") {
  | "hi" => "You said 'hi'!"
  | _ => "You didn't say hi :("
  | exception (Sys_error _) => "error reading your saltation"
});
```

That's all!

# What's Reason?

The code in this post is in [Reason](http://facebook.github.io/reason); an
alternative parser for the OCaml compiler.
