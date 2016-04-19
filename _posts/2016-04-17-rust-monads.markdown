---
layout: post
title:  "Exploring Monads with Rust"
date:   2016-04-17 12:31:33
categories: rust monads
---

**Disclaimer**: Rust does not have monads.

Rust doesn't have _higher-kinded_ types. Hopefully, in 5 minutes:

  1. you understand monads better and
  2. you understand why not having _higher-kinded_ types means not having monads

Anyways, in Haskell, you can do this:

~~~haskell
let a = do
  x <- [2,3,4]
  y <- [4,5,6]
  return [x,y]
~~~

The result is `a = [[2,4],[2,5],[2,6],[3,4],[3,5],[3,6],[4,4],[4,5],[4,6]]`.

Ignoring the syntax for a moment, this generally maps to:

~~~
If x is one of [2,3,4] and y is one of [4,5,6] what can [x, y] be?
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
this list comprehension arises from the monadic definition of lists... and can almost work in [Rust](http://www.rust-lang.org).

Let's try to build the same thing in Rust and see where things fall apart!

## Sneak peek!
By the end of the post, this will compile:

~~~rust
let a: Vec<Vec<i32>> = perform!{
  vec![1,2] => x;
  vec![3,4] => y;
  vec![vec![x, y]];
};

~~~

And `a` still equals (the vector equivalent of) `[[2,4],[2,5],[2,6],[3,4],[3,5],[3,6],[4,4],[4,5],[4,6]]`.

# Monads

There's a [fancy set of constraints](https://wiki.haskell.org/Monad_laws) about what makes a true monad and what does not. For now, I'm just going to explain the type signatures and you can look into the rest if you are so inclined :)

These are the type signatures of a monad's defining methods in Haskell:

~~~haskell
class Monad M where
  returns :: a -> M a
  bind :: M a -> (a -> M b) -> M b 
~~~

`returns` is a function that takes an arbitrary type and returns a Monad of that type.

  - like a Box of type `M` (A jar, for example)  with something of type `a` inside. (Let's say `a` is candy)

`bind` takes a monad `M` and a function from type `a` to `M b`. `bind` then returns an `M b`.

  - Given two parameters: (1) "a jar of candies" and (2) "the action of eating the candies and placing the wrappers in the now empty jar", `bind` defines how one removes the candies from the jar and performs this action.


## The Trait

Rust operates with typeclasses similar to Haskell called 'Traits'.

~~~rust
trait Monad<T,A>: Sized {
    fn returns(inside: T) -> Self;
    fn bind<'a>(outside: Self, op: Box<Fn(T) -> A + 'a>) -> A;  
}
~~~

You can see Rust is holding it's own here quite well! But there is poison in the wine.

`A` can not be a higher-kinded type. In other words, whenever you provide an implementation of this Monad trait, you can't just say that `A` has to be a Monad, you have to say that it's a Monad of integers, or a Monad of floats. If you want both, you have to copy the implementation for each.

But let's try it out anyways, shall we!

## The Option Monad

`Option` is the same thing as Haskell's `Maybe`. An `Option<T>` type is either `Some(inside: T)` or `None`.

So if we want to define `returns`, we are trying to put an arbitrary object into a box. This can be done by just saying `Some(object)`. Sweet!

~~~rust
fn returns(inside: T) -> Option<T> {
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

Vectors, too, can be thought of a box. Let's start with `returns`:

~~~rust
fn returns(inside: T) -> Vec<T> {
  vec!(inside)
}
~~~

Easy, take an element, put in a list. 

Next, `bind` is a little more complicated.

We need to come up with a function that will apply an operation (`a -> [a]`) to a list (`[a]`) and get a list of items (`[a]`). You might think "`map` applies an operation to a list!", and you'd be totally right!

The only problem is the return value of bind: A list of items (`[a]`).

If we map with an operation that produces lists, we'll get a list of list of items (`[[a]]`)

Instead, why don't we concatenate the result? Hurray we return the type `[a]` and the world doesn't end!

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

You can't replace `T` with a parametrized type, in other words.

# Duplicate Code

One solution is to write a bunch of code over again. This allows rust to work similarly to Haskell, but you have to specify the types that will work ahead of time, and you have to literally copy the code. &#9785;

I've taken the pleasure of coping the code [beforehand](https://gist.github.com/Charlesetc/683c036e550ea833a70be83dda5ff4e5). This defines the same implementation for:

~~~rust
impl<T> Monad<T, Vec<Vec<T>>> for Vec<T> { }
~~~

Ignoring the ugliness for the time being, you'll see this actually works:

~~~rust
let result = Monad::bind(vec![2,3,4], Box::new(|x| 
    Monad::bind(vec![4,5,6], Box::new(|y| 
        vec!(vec![x,y])
    ))  
)); 

assert_eq!(result, vec![vec![2,4], 
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

But I still wanted it prettier.

# Macros to the Rescue.


