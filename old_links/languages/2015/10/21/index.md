---
layout: post
title:  "the Problems"
date:   2015-10-21 12:31:33
categories: languages
---

I like programming languages, so I was thinking about what I would want in my favorite one.

Here are the basic essentials for a language to have a chance at being my favorite:

1. Strict Type Checking
2. No Nil Pointer
3. Green Threads with both go-like channels and mutexes.
4. Compiles to binary, without a virtual machine.
5. Still runs on all platforms that I care about.
6. Parametric Polymorphism
7. Methods with dot syntax
8. Fast compilation, fast running
9. Lisp- or scheme-style macros of some sort
10. User specified Operators with precedence
11. Mutation
12. A clean syntax (I'm aware how subjective this is)

Okay! Let's see how languages do:

## Go

Fails on: 2,6,9,10

Nil pointers are annoying but not a dealbreaker.
Lack of polymorphism is where it falls apart.

## Python

Fails on: 1,2,3,4,8,9,10

Too many to talk about.

## C++

Fails on: 2,3,8,9,10,12

## Java

Fails on: 2,4,9,10,12

## Haskell

Fails on: 7,9,11

Easily the best so far, but that lack of mutation is a killer. State is so useful sometimes.
You'll notice it's the only one that passes 10, and the only one that fails 11.

## Rust

Fails on: 3,10,12

The lack of green threads is unfortunate, and damn is it ugly, but other than that rust is a great contender.

# Edit

Revisiting this post, I see that OCaml wasn't mentioned!

## OCaml

Fails on: 7

__Damn.__ I didn't even know about OCaml!



