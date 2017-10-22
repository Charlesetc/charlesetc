---
title: "**Ada**pting for safety"
---

There have been a lot of new compiled, strongly typed
languages that have been popping up in recent years:

* Crystal (2014)
* Swift (2014)
* Hack (2014)
* Kotlin (2011)
* Typescript (2012)
* Rust (2010)
* Go (2009)
* Idris (2009)
* Julia (2012) --- *Julia has a type system, albeit not required, and is
  performance-driven.*

And even some older languages that have been having a
surge in popularity:

* Scala (2003)
* D (2000)
* OCaml (1996) --- *There have recently been two huge OCaml
  projects funded by Facebook and Bloomberg.*

At least from where I stand, there's been a trend in recent
years away from dynamic languages like Ruby and Python, and
towards stricter type systems and better performance.

There has also been some research done into languages that
don't need garbage collection, namely Rust and D.

But I think there's one language being left out.

# Ada

Ada is **the original** strongly-typed language. It was developed
by the US Department of Defense in 1980 to be **safe and fast** enough
for military, rocket, and space programming. The Boeing 777,
for example, runs on 99.9% Ada.

Ada has **optional garbage collection**, and seems to support
a wide range of programming styles, including
OOP,contract-based programming, and java-like interfaces.

And guess what? It's got first class support for
**immutability**! From 1980! You can pass an object into
a function with full assurance that it will not be mutated.

But you might say, *"Hold up just one second: Aren't old
languages usually super lacking in some departments? Like
concurrency or parallelism or something?"*

Well totally yeah! Excluding Erlang, all the old languages I'm
familiar with (and some not-so-old languages) generally have
a pretty tough time in this ol' mutliprocessor world of ours.
C, C++, OCaml, Fortran, COBOL, Prolog, most scheme
implementations, etc all have trouble with OS-independent
parallelism. Not to mention Ruby, Python, and most scripting
languages.

But wait! You guessed it! Ada has it's own **concurrency**
abstraction called **Tasks** that can be concurrently
distributed over several threads. Think Go's "goroutines" but,
wait, designed in **1980.**

There are a lot of other things that Ada seems to do right ---
packages & parallel compilation, (avoiding) pointers, generics
/ templates --- maybe I'll write about them another time. :)

# Summing up

I am hoping that learning Ada will teach me a lot about
what a mature, strongly-typed language looks
like.

It seems there was a collective decision to advance C instead
of Ada. We spent 20 years working with more and more dynamic
languages, and all of a sudden popular opinion is veering
towards safe, compiled languages. Maybe Ada will fill this
gap! 👻
