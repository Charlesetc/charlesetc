---
layout: post
title:  "Rust, Monads, and List Comprehensions"
date:   2015-11-08 12:31:33
categories: rust
---

Anyone transitioning from Haskell to another language will inevitably try to make some form of monads. 

It's true, Haskell's dependence on them is directly a result of it's immutable nature. Rust doesn't really need monads the way Haskell does, nor is it capable of having them. That said, I really like the way Haskell's list comprehensions work and I thought rewriting them in Rust would be cool. Don't worry if you don't have experience with monads, I'll cover them along the way.

Anyways, in Haskell, you can do this:

```haskell
let a = do
  x <- [2,3,4]
  y <- [4,5,6]
  return [x,y]
```

The result is `a = [[2,4],[2,5],[2,6],[3,4],[3,5],[3,6],[4,4],[4,5],[4,6]]`.

The coolest part is that this isn't built into the language &mdash; 
this list comprehension arises from the monadic definition of lists... and can also work in [Rust](http://www.rust-lang.org).

By the end of the post, this will compile:

```rust
let a: Vec<Vec<i32>> = perform!{
  vec![1,2] => x;
  vec![3,4] => y;
  vec![vec![x, y]];
};

```

And `a` still equals (the vector equivalent of) `[[2,4],[2,5],[2,6],[3,4],[3,5],[3,6],[4,4],[4,5],[4,6]]`.

# Monads

Monads are not unique to Haskell, nor are they built into Haskell. Monads arise happily out of Haskell's awesome type system, and they aren't too hard to think about. 

__A monad is a box__.

A definition for a monad relies on two functions: `just` and `bind`. 

  1. `just` takes some type T and puts it into a brand new box.
      
      This is really general; the actual implementation depends on which monad.

  2. `bind` takes two arguments:

      (1) a box of type A, 

      (2) a function that can unbox whatever is inside the first argument and will return a box of type B.

      and `bind` returns a box of type B.

Here are the possible definitions in Rust.

```rust
fn just(inside: T) -> A<T>;
fn bind<'a>(outside: A<T>, op: Box<Fn(T) -> B<T> + 'a>) -> B<T>;
```

Now `bind` and `just` have very sensible types. Whenever you get a fancy new box you have two questions: 

"How do I put things in it" and "How do I take things out of it"

# Monads in Rust

I want to be very clear: Rust cannot have monads like Haskell does. Rust doesn't have higher-kinded types. In Rust, it's impossible to say "for any arbitrary box" in a type signature.

That said, if we're overly explicit about types we can model how monads behave for the time being. So let's get started!

## The Trait

Rust operates with typeclasses similar to Haskell called 'Traits'. Here are the requirements to fulfill the monad trait:

```rust
trait Monad<T,A>: Sized {
    // return in haskell
    fn just(inside: T) -> Self;
    // (>>=) in haskell
    fn bind<'a>(outside: Self, op: Box<Fn(T) -> A + 'a>) -> A;  
}
```

You'll start to see the limitations of Rust here; you have to specify the second type when you're implementing the trait.
This means we'll potentially need identical implementations of the same trait, all of which Haskell gets for free.

## The Option Monad

`Option` is the same thing as Haskell's `Maybe`. An `Option<T>` type is either `Some(inside: T)` or `None`.

So if we want to define `just`, we are trying to put an arbitrary object into a box. This can be done by just saying `Some(object)`. Sweet!

```rust
fn just(inside: T) -> Option<T> {
    Some(inside)
} 
```

In order to implement `bind`, we need to take an box and apply a function to its contents.

```rust
fn bind<'a>(outside: Self, op: Box<Fn(T) -> Self + 'a>) -> Self {
    match outside {
        Some(a) => op(a),
        None => None,
    }   
}
```

This says "If there is something inside the box, apply the function to that, and return the result. Otherwise, just return an empty box."

There are two things to take away from this. 

  1. You see how `Option` can be monadic right? It's pretty much a  box. 

  2. The job of `bind` is to unbox its other argument and apply the function to the best of it's ability.

## The List Monad

Now on to the main point: Lists!

Lists, too, can be thought of a box. Let's start with `just`:

```rust
fn just(inside: T) -> Vec<T> {
  vec!(inside)
}
```

Easy, take an element, put in a list. 

Next, `bind` is a little more complicated.

We are given an operation, and we want to apply the operation to a list of elements, and then we want to return a list of elements.

At first this seems quite simple, just use `map` and we get another list, right? The problem is that the operation returns a box, so we're left with a list of lists.

Luckily, Haskell can be a savior here: we can `map` and then concatenate the resulting lists to make one big list.

It's actually somewhat faster to fold so that's how I've done it here:

```rust
fn bind<'a>(outside: Self, op: Box<Fn(T) -> Self + 'a>) -> Self
{
    outside
        .into_iter()
        .fold(vec![], |mut aggregate, x| {
            let mut c = &mut op(x);
            aggregate.append(c);
            aggregate
        })
}
```

# Are we there yet?

Ahahah, hahaha, ahaha. Not quite.

So with our definition of the Option monad, we can chain functions that return Option types and have them stop if any of the operations fail. This is kind of fun, but what about list comprehensions?

Okay first of all you have to realize how amazing Haskell is. Take that example from before:

```haskell
let a = do
  x <- [2,3,4]
  y <- [4,5,6]
  return [x,y]
```

This is actually using the one monadic definition for lists to return a list of lists. That's because the true definition of a monad is more sophisticated than the one's we've defined in rust.

Our definitions so far in rust:

`bind` is a function that takes a box of X, a function from X to a box of X, and returns a box of X.

The real definition:

`bind` is a function that takes a box of X, a function from X to a box of Y, and returns a box of Y. 

This is where Rust falls behind. There is no way to say 'box of Y' for an unspecified box _and_ for an unspecified Y.

# Duplicate Code

One solution is to write a bunch of code over again. This allows rust to work similarly to Haskell, but you have to specify the types that will work ahead of time, and you have to literally copy the code. &#9785;

```rust
impl<T> Monad<T, Vec<T>> for Vec<T> {

    fn just(inside: T) -> Self {
        vec!(inside)
    }

    fn bind<'a>(outside: Self, op: Box<Fn(T) -> Self + 'a>) -> Self
    {
        outside
            .into_iter()
            .fold(vec![], |mut agg, x| {
                let mut c = &mut op(x);
                agg.append(c);
                agg
            })
    }
}

impl<T> Monad<T, Vec<Vec<T>>> for Vec<T> {

    fn just(inside: T) -> Self {
        vec!(inside)
    }

    fn bind<'a>(outside: Self, op: Box<Fn(T) -> Vec<Vec<T>> + 'a>) -> Vec<Vec<T>>
    {
        outside
            .into_iter()
            .fold(vec![], |mut agg, x| {
                let mut c = &mut op(x);
                agg.append(c);
                agg
            })
    }
}
```

Ignoring the ugliness for the time being, you'll see this type checks:

```rust
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
```

This is pretty good! I mean, both the implementation and the usage are disgusting, but I think you probably understand monads a bit better, and whether you like it or not you've been exposed to [Rust](http://www.rust-lang.org) a bit more! I call that a win-win.

But I still want it prettier.

# Macros to the Rescue.


