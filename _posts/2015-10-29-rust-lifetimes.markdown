---
layout: post
title:  "Rust Lifetimes"
date:   2015-10-29 12:31:33
categories: rust lifetimes
---

Lifetimes are pretty much what makes rust rust. 

Easy concurrency, straightforward memory allocation, and overall data safety would not be at all possible without lifetimes.

But they are also tricky, and this is aimed at helping people understand the concepts and syntax.

# What are Lifetimes?

Rust is a unique language in that it deallocates memory on the heap without manually calling `free`, 
while at the same time having no need for a garbage collector.
Rust knows when it's okay to get rid of an object by keeping track of its lifetime. 

Think of it as explicit reference counting.

So every reference in Rust (i.e. pointer) has a lifetime. Sometimes the compiler can figure it out and it's not 
necessary to write it, but often you will have to explicitly tell the compiler.

Things like integers, floats, and other data types whose size can be known at compile time 
do not need lifetimes because they are stored on the stack,
and deallocation is handled when the function returns. 
(Believe it or not, rust can even store some *closures* this way.)
However, anything that is accessed by a pointer needs a lifetimes.

There are two reasons for this.

1. As I've said, to know when to deallocate objects on the heap.

2. The other is to know when it's safe to dereference a pointer, regardless of whether the pointee is stored on the stack or the heap.

Now, **you are not in charge of defining lifetimes.** All you've got to do is give names to the ones that already exist.

# Where do Lifetimes come from?

Lifetimes are always named with the same syntax. 
One can look like `<'a>`, `<'b>`, or `<'c>`, 
but they are generally one letter and always prefaced 
by an apostrophe.

Note well: You will only ever write a lifetime within a type declaration. 

Okay, so what are some things that define lifetimes?

## Functions

This is a biggie. A function defines a lifetime for everything put on the stack during it.

This makes sense: If you want to take a reference to something on the function stack, you have to be prepared for it to disappear when the function is over.

In go, you can do this:

{% highlight go %}
func example_function() *int {
  b := 3
  return &b
}

func main() {
  fmt.Println(*example_function);
}
{% endhighlight %}

However, you cannot do that in rust:

{% highlight rust %}
fn example_function<'a>() -> &'a i32 {
  let b = 3;
  &b
}

fn main() {
  println!("{}", example_function()); // this does not compile
}
{% endhighlight %}

The reason is that `&b` does not live long enough to be dereferenced outside of the function that made it.

So just to explicitly point out the syntax:

`function_name<'a>` names the lifetime defined by this function.

`&'a i32` says "This is a reference to an integer that has lifetime `a`", 
which means it lasts as long as the function where the lifetime was defined.

(Now at this point you might be asking how you actually would return a reference to `3` in rust... 
that's a more complicated question and the answer is to put it on the heap. Look up the`box` type to learn more.)

But on to bigger fish!

## Structs

Another place lifetimes can be defined are with structs and their `impl`-ementations.


