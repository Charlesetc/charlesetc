---
layout: post
title:  "Why Functions"
date:   2015-12-18 12:31:33
categories: functions
---

Everybody uses functions all the time. But have you thought about why?

# School

What I learned in school was that a function takes an input and gives you an output. 

One way of writing a function was just a mapping of points to points:

|x  |  | y |
|:--|:--|:--|
|-3 |  | 9 |
|-2 |  | 4 |
|-1 |  | 1 |
|0  |  | 0 |
|1  |  | 1 |
|2  |  | 4 |
|3  |  | 9 |

It took me a while to understand how this is the same as a function that maps sets to sets.

&fscr; &colon; &reals; &rightarrow; &reals;

&fscr; (x) &equals; x ^ 2

# This is CS

When programming, functions are easy to think of in this way too.

```c
string f(x int) {
  return sprintf("%d\n", x);
}
```

Here we specify two sets that we are dealing with a domain (the set of all 32-bit integers) and a codomain (the set of all strings).
The range isn't actually specified in C's type system, but it's all the strings that look like an integer followed by a newline.

Now this way of thinking about functions is really interesting and also very valuable sometimes, but that's not what I want to point out.

# Why Functions

It's accepted that a function is an abstraction on top of machine code that allows programmers to more closely approximate mathematical concepts.

This is true and very helpful... in haskell, idris, and coq. But this is __not__ the purpose or goal of most functions. 

Functions make code better for two reasons:

  1. Allow you to be explicit about state.
  2. Allow you to discard internal state.

## Explicit State

Using functions says "This function will return the same value each time it's called with the same inputs"

Obviously this isn't true in a lot of cases: global variables, closures, etc. Nonetheless, nnnnnnnn

# Implications

## Why Monads



