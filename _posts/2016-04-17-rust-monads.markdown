---
layout: post
title:  "Exploring Monads with Rust"
date:   2016-04-17 12:31:33
categories: rust monads
---

**Disclaimer**: Rust can not have monads.

Rust doesn't have _higher-kinded_ types. Hopefully, in 5 minutes:

  1. you understand monads better and
  2. you understand why monads require higher-kinded types.

Anyways, in Haskell, you can do this:

~~~haskell
let a = do
    x <- [2,3,4]
    y <- [4,5,6]
    return [x,y]
~~~

The result is `a = [[2,4],[2,5],[2,6],[3,4],[3,5],[3,6],[4,4],[4,5],[4,6]]`.

Ignoring the syntax, this generally maps to:

~~~
If x is one of [2,3,4] and y is one of [4,5,6] what can the expression [x, y] be?
~~~

Alternatively, these also work:

~~~haskell
let a = do
    x <- [2,3,7]
    y <- [4,5,6]
    return (max x y)

    -- This evaluates to:
    -- [4, 5, 6, 4, 5, 6, 7, 7, 7]
~~~
 
~~~haskell
let a = do
    x <- [2,3,4]
    y <- [4,5,6]
    return (x == y)

    -- This evaluates to:
    -- [False, False, False, False, False, False, True, False, False]
~~~


The coolest part is that this isn't built into the language &mdash; 
this way of comprehending lists (_list comprehensions_, if you will) arises from the monadic definition of lists... and can almost work in [Rust](http://www.rust-lang.org).

Let's try to build the same thing in Rust and see where things fall apart!

## Sneak peek!

An example in Rust that's analogous to Haskell's:

~~~rust
let a: Vec<Vec<i32>> = perform!{
    vec![1,2] => x;
    vec![3,4] => y;
    vec![vec![x, y]];
};
~~~

And `a` still equals (the vector equivalent of) `[[2,4],[2,5],[2,6],[3,4],[3,5],[3,6],[4,4],[4,5],[4,6]]`.

A Rust macro makes this pretty, but we'll go through the function calls that do the heavy lifting.

# Monads

There's a [fancy set of constraints](https://wiki.haskell.org/Monad_laws) about what makes a true monad and what does not. For now, I'm just going to explain the type signatures and you can look into the rest if you are so inclined 😊

There are two functions that comprise an implementation for the monad typeclass: `just` and `bind`.

The Haskell type signatures for the methods that define a monad:

~~~haskell
class Monad M where
    just :: a -> M a
    bind :: M a -> (a -> M b) -> M b
~~~

`just` is a function that takes an arbitrary type and returns a monad of that type.

  - like a Box of type `M` (A jar, for example)  with something of type `a` inside. (Let's say `a` is candy)

`bind` takes a monad `M a` and a function from type `a` to `M b`. `bind` then returns an `M b`.

  - Given two parameters: (1) "a jar of candies" and (2) "the action of eating the candies and placing the wrappers in the now empty jar", `bind` defines how one removes the candies from the jar and performs this action.

**Disclaimers:**

  - `just` is actually called `return` in Haskell. But that's a keyword in Rust, so...
  - `bind` is referred to as "bind", but Haskell uses the symbol `>>=`.
  - There is also `>>`, but I'm glossing over it for simplicity. [Link here](http://hackage.haskell.org/package/base-4.8.2.0/docs/Prelude.html#v:-62--62-)



## The Trait

Rust operates with typeclasses similar to Haskell called 'Traits'.

~~~rust
trait Monad<T,A>: Sized {
    fn just(inside: T) -> Self;
    fn bind<'a>(outside: Self, op: Box<Fn(T) -> A + 'a>) -> A;
}
~~~

You can see Rust is holding it's own here quite well! However, darkness falls across the land:

`A` can not be a higher-kinded type. In other words, whenever you provide an implementation of this Monad trait, you can't just say that `A` has to be a Jar, you have to say that it's a Jar of candies, or a Jar of fireflies. If you want to bind to both, you have to copy the implementations.

But let's try it out anyways!

## The Option Monad

`Option` is the same thing as Haskell's `Maybe`. An `Option<T>` type is either `Some(inside: T)` or `None`.

So if we want to define `just`, we are trying to put an arbitrary object into a box. This can be done by just saying `Some(object)`. Sweet!

~~~rust
fn just(inside: T) -> Option<T> {
    Some(inside)
} 
~~~

In order to implement `bind`, we need to take an box and apply a function to its contents.

~~~rust
fn bind<'a>(outside: Self, op: Box<Fn(T) -> Self + 'a>) -> Self {
    match outside {
        Some(a) => op(a),
        None => None,
    }   
}
~~~

This says "If there is something inside the box, apply the function to that, and return the result. Otherwise, just return an empty box."

What can you take away from this?

___The types are WRONG!___

  Monads promise this:

~~~
bind :: M a -> (a -> M b) -> M b 
~~~
 
  But we only were able to implement this:

~~~
bind :: M a -> (a -> M a) -> M a 
~~~

Sure, we could hardcode a different type - but we can't reference "`M` of `b`" where `b` is a unstated type. Haskell does just that.

## The Vector Monad

But let's try once more: Vectors!

Vectors, too, can be thought of as a box. Let's start with `just`:

~~~rust
fn just(inside: T) -> Vec<T> {
    vec!(inside)
}
~~~

Easy, take an element, put it in a list.

Next up, `bind`:

We need to come up with a function that will apply an operation (of type `a -> [a]`) to a vector (of type `[a]`) and get a vector of items (`[a]`). You might think "`map` applies an operation to a vector!" - and you'd be totally right!

The only problem is the return value of bind: A vector of items (`[a]`).

If we map with an operation that returns a vector, we'll get a vector of vector of items (`[[a]]`)

Luckily, we can concatenate the results and the types work out!

(There are probably other ways to implement vectors as monads, but this is how Haskell's standard library does it.)

~~~rust
fn bind<'a>(outside: Self, op: Box<Fn(T) -> Vec<T> + 'a>) -> Vec<T>
{
    outside
    .into_iter()
    .fold(vec![], |mut aggregate, x| {
        let mut c = &mut op(x);
        aggregate.append(c);
        aggregate
    })
}
~~~

Do you see the problem again this time? `T` is not a higher-kinded type. In Rust, one can't say "Let `T` be the type  __vector of something__" -- one can only say "Let `T` be the Integer type" or "Let `T` be the type __vector of f32__".

You can't replace `T` with a parameterized type, in other words.

# Duplicate Code

One solution is to write a bunch of code over again. This allows Rust to work similarly to Haskell, but you have to specify the types that will work ahead of time, and you have to literally copy the code. 😞

I've taken the pleasure of copying the code [ahead of time](https://gist.github.com/Charlesetc/683c036e550ea833a70be83dda5ff4e5). This defines the same implementation for both:

~~~rust
impl<T> Monad<T, Vec<T> for Vec<T> { }
impl<T> Monad<T, Vec<Vec<T>>> for Vec<T> { }
~~~

Ignoring the ugliness for the time being, you'll see this now works:

~~~rust
let result = Monad::bind(vec![2,3,4], Box::new(|x| 
    Monad::bind(vec![4,5,6], Box::new(|y| 
        vec!(vec![x,y])
    ))
)); 
~~~

and `result` equals:

~~~rust
vec![vec![2,4],
     vec![2,5],
     vec![2,6],
     vec![3,4],
     vec![3,5],
     vec![3,6],
     vec![4,4],
     vec![4,5],
     vec![4,6]]);
~~~

This is pretty good! It's nothing compared to Haskell's type system, but it does perform the same function calls and return the same result!

This behaviour comes directly from how we defined `bind` for vectors, and this is exactly how list comprehensions in Haskell work!

But I still promised prettier! 🌸

# Macros to the Rescue.

Now if we add [two (fairly simple) macros](https://gist.github.com/Charlesetc/32a5c5be1f1edf1d9d2ca644c50a86cf), we end up with code that looks very similar to the Haskell we saw in the beginning. (Not going into macros in this post, so keep your eyes peeled!)

The macros transform the following code into code that uses only `bind` and `just`.

**Rust:**

~~~rust
let a: Vec<Vec<i32>> = perform!{
    vec![1,2] => x;
    vec![3,4] => y;
    vec![vec![x, y]];
};
~~~

**Haskell:**

~~~haskell
let a = do
    x <- [1,2]
    y <- [3,4]
    return [x,y]
~~~

And that's it! Something along the lines of monads in Rust. All code is on [github](https://github.com/Charlesetc/exploring-monads-with-rust).
