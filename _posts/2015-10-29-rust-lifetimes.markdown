---
layout: post
title:  "Rust Lifetimes"
date:   2015-10-29 12:31:33
categories: rust
---

Lifetimes are pretty much what makes Rust Rust. 

Easy concurrency, straightforward memory allocation, 
and overall data safety would not be possible without explicit lifetimes.

But they are also tricky, and this is aimed at helping people understand the concepts and syntax.

# What are Lifetimes?

Rust is a unique language in that it deallocates memory on the heap without requiring the writer to call `free`, 
while at the same time having no need for a garbage collector.
Rust knows when it's okay to use a reference by keeping track of its lifetime. 

Each time a reference is returned by or passed into a function, Rust checks at compile time to make sure it fulfills the lifetime requirement specified in the type signature.

So every reference in Rust (i.e. pointer) has a lifetime. Sometimes they can be elided 
and the compiler can infer them. Nonetheless, you cannot program Rust without knowing how to specify lifetimes.

Lifetimes fulfill two roles for Rust:

1. To know when it's safe to dereference a pointer

2. To allow data to be shared safely

Now, **you are not in charge of defining lifetimes.** 

Sometimes, however, you will have to give names to existing lifetimes in order to change the default behavior of the compiler.

# Where do Lifetimes come from?

Lifetimes are always named with the same syntax. 
They look like `<'a>`, `<'b>`, or `<'c>`, 
and they are generally one letter prefaced 
by an apostrophe.

When you use one, though, there is more syntax involved. 
Depending on the context they can look like one of: `something<'a>`, `Box<something + 'a>` or `&'a something`

Note well: You will only ever write a lifetime within a type declaration. 

So if you don't define lifetimes, what does?

# Functions

This is a biggie. A function can define a lifetime that can be used in it's type declarations.

This makes sense: If you want to take a reference to something on the function stack, you have to be prepared for it to disappear when the function is over. And if not, you need to make sure it has an appropriate lifetime.

In Go, you can do this:

```go
func example_function() *int {
  b := 3
  return &b
}

func main() {
  fmt.Println(*example_function());
}
```

However, you cannot do that in Rust:

```rust
fn example_function<'a>() -> &'a i32 {
  let b = 3;
  &b // this does not compile
}

fn main() {
  println!("{}", example_function()); 
}
```

The reason is that `&b` does not live long enough to be dereferenced outside of the function that made it.

So just to explicitly point out the syntax:

`example_function<'a>` is saying "for any lifetime called `'a`...". You can then go on to use this lifetime in the remainder of the type definition.

`&'a i32` says "This is a reference to an integer that has lifetime `'a`", 
which means it has to last as long as "any lifetime". However, `b` happens to only have a lifetime that lasts as long as the function's scope, so Rust complains.

(Now at this point you might be asking how you actually would return a reference to `3` in Rust... 
that's a more complicated question and the answer is to put it on the heap. Look up the `Box` type to learn more.)

But on to bigger fish!

# Structs

Structs also define lifetimes.

Think about it like this:

If a struct includes a reference to something, then that reference damn sure better last as long as the struct.

Here's how you can make sure of that:

## Wrong example:

```rust
struct Sheep {
  age: &i32,
}

fn main() {
    let a = 3;
    let s = Sheep { age: &a };
    println!("{};", s)
}
```

This gives the following error:

```ruby
error: missing lifetime specifier [E0106]
        age: &i32,
             ^~~~ 
```

Rust is mad. 
In the struct definition, you haven't told it how long the reference to the `i32` is allowed to stay around.
And yet, in order for your code to be safe, it has to stick around for at least as long as the struct.

## Right Example

```rust
struct Sheep<'c> {
  age: &'c i32,
}

fn main() {
    let a = 3;
    let s = Sheep { age: &a };
    println!("{};", s)
}
```

You'll notice that not much here has changed. But now Rust has pronounced your code safe &mdash; Hurray! 

Here are the changes:

1. `Sheep<'c>` instead of `Sheep`

  This is making a parameter for the struct in Rust &mdash; It's lifetime might have to depend on the lifetimes of its fields, so now you are able to say how and which ones. (Note: you can do things like `Sheep<'c, 'd>` if you need more than one lifetime.)

2. `age: &'c i32` instead of `age: &i32`

    Now this says that the integer has to live for as long as the struct.

This is **insanely** impressive. 
With these small additions, Rust will now tell you if there is any chance of you having invalid data,
even across threads. AND all of this happens at compile time without affecting the efficiency of your code.

# Implementations

There is one other place where a lifetime can be defined &mdash; Implementations.

It's very similar to structs. Each implementation is an implementation of a certain
trait for a struct. So if the struct requires an explicit lifetime, you need to have one to give it.

## Wrong Example
```rust
struct Sheep<'c> {                                                             
  age: &'c mut i32,
}                                                                              
                                                                               
impl Sheep {
    fn grow_old(&mut self)  {
        *self.age += 100
    }                    
}                   
```

This fails with the following:

```ruby
error: wrong number of lifetime parameters: expected 1, found 0 [E0107]
        impl Sheep {
             ^~~~~
```

## Right Example

What's the problem?

`Sheep` takes a lifetime parameter now, so one must be supplied:


```rust
struct Sheep<'c> {                                                             
  age: &'c mut i32,
}                                                                              
                                                                               
impl<'c> Sheep<'c> {
    fn grow_old(&mut self)  {
        *self.age += 100
    }                    
}
```

Note that `impl<'c>` names a new lifetime and `Sheep<'c>` says that all 
`self`'s in this implementation have at least the lifetime `'c`.

This is a lot like an extenuation of the lifetimes with structs, but there 
is strange syntax with the `impl<'c> Sheep<'c>` so I wanted to point it out.

# The End

And that is all I know about lifetimes in Rust!

If you're interested, here is a [concise reference]({% post_url 2015-10-31-lifetime-reference %}) for the syntax used with lifetimes.

