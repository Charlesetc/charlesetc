---
layout: post
title:  "Rust Lifetimes"
date:   2015-10-29 12:31:33
categories: rust lifetimes
---

Lifetimes are pretty much what makes Rust Rust. 

Easy concurrency, straightforward memory allocation, and overall data safety would not be at all possible without lifetimes.

But they are also tricky, and this is aimed at helping people understand the concepts and syntax.

# What are Lifetimes?

Rust is a unique language in that it deallocates memory on the heap without manually calling `free`, 
while at the same time having no need for a garbage collector.
Rust knows when it's okay to get rid of an object by keeping track of its lifetime. 

Think of it as explicit reference counting.

So every reference in Rust (i.e. pointer) has a lifetime. Sometimes the compiler can figure it out and it's not 
necessary to write it down, but often you will have to explicitly tell the compiler.

Things like integers, floats, and other data types whose size can be known at compile time 
do not need lifetimes because they are stored on the stack,
and deallocation is handled when the function returns. 
(Believe it or not, Rust can even store some closures this way.)
However, anything that is accessed by a pointer needs a lifetimes.

In total, lifetimes fulfill two roles for Rust:

1. As I've said, to know when to deallocate objects on the heap.

2. The other is to know when it's safe to dereference a pointer, never mind where it points.

Now, **you are not in charge of defining lifetimes.** 

Sometimes, however, you will have to give names of existing lifetimes in order to change the default behavior of the compiler.

# Where do Lifetimes come from?

Lifetimes are always named with the same syntax. 
They look like `<'a>`, `<'b>`, or `<'c>`, 
and they are generally one letter prefaced 
by an apostrophe.

Note well: You will only ever write a lifetime within a type declaration. 

So if you don't define lifetimes, what does?

# Functions

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

However, you cannot do that in Rust:

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

`function_name<'a>` names the lifetime defined by this function, called `'a`.

`&'a i32` says "This is a reference to an integer that has lifetime `'a`", 
which means it lasts as long as the function where the lifetime was defined.

(Now at this point you might be asking how you actually would return a reference to `3` in Rust... 
that's a more complicated question and the answer is to put it on the heap. Look up the`box` type to learn more.)

But on to bigger fish!

# Structs

Structs also define lifetimes.

Think about it like this:

If a struct includes a reference to something, then that reference damn sure better last as long as the struct.

Okay so here's how you can make sure of that:

## Wrong example:

{% highlight rust %}
struct Sheep {
  age: &i32,
}

fn main() {
    let a = 3;
    let s = Sheep { age: &a };
    println!("{};", s)
}
{% endhighlight %}

This gives the following error:

{% highlight ruby %}
error: missing lifetime specifier [E0106]
        age: &i32,
             ^~~~ 
{% endhighlight %}

Rust is mad. 
In the struct definition, you haven't told it how long the reference to the `i32` is allowed to stay around.
And yet, in order for your code to be safe, it has to stick around for at least as long as the struct.

## Right Example

{% highlight rust %}
struct Sheep<'c> {
  age: &'c i32,
}

fn main() {
    let a = 3;
    let s = Sheep { age: &a };
    println!("{};", s)
}
{% endhighlight %}

You'll notice that nothing here has changed but the types. But now Rust has pronounced your code safe &mdash; Hurray! 

Here are the changes:

1. `Sheep<'c>` instead of `Sheep`

    This is not doing anything concrete. It's just giving a name to the lifetime that Sheep structs can last for.

2. `age: &'c i32` instead of `age: &i32`

    Now this says that the integer has to live for as long as the struct.

This is **insanely** impressive. 
With these small additions, Rust will now tell you if there is any chance of you having invalid data,
even across threads.
AND it will free all the memory safely!

# Implementations

There is one other place where a lifetime can be defined &mdash; Implementations.

This is very similar to structs. Each implementation is an implementation of a certain
trait for a struct. So if the struct requires an explicit lifetime, you need to have one to give it.

## Wrong Example
{% highlight rust %}
struct Sheep<'c> {                                                             
  age: &'c mut i32,
}                                                                              
                                                                               
impl Sheep {
    fn grow_old(&mut self)  {
        *self.age += 100
    }                    
}                   
{% endhighlight %}

This fails with the following:

{% highlight ruby %}
error: wrong number of lifetime parameters: expected 1, found 0 [E0107]
        impl Sheep {
             ^~~~~
{% endhighlight %}

## Right Example

What's the problem?

`Sheep` takes a lifetime parameter now, so one must be supplied:


{% highlight rust %}
struct Sheep<'c> {                                                             
  age: &'c mut i32,
}                                                                              
                                                                               
impl<'c> Sheep<'c> {
    fn grow_old(&mut self)  {
        *self.age += 100
    }                    
}
{% endhighlight %}

Note that `impl<'c>` names a new lifetime and `Sheep<'c>` says that all 
`self`'s in this implementation have at least the lifetime `'c`.

This is a lot like an extenuation of the lifetimes with structs, but there 
is strange syntax with the `impl<'c> Sheep<'c>` so I wanted to point it out.

# The End

And that is all I know about lifetimes in Rust!

If you're interested, here is a [concise reference]({% post_url 2015-10-31-lifetime-reference %}) for the syntax used with lifetimes.

