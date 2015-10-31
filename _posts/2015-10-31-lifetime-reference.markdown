---
layout: post
title:  "Lifetime Reference"
date:   2015-10-31 12:31:33
categories: rust
---

Places in Rust where you use any lifetime syntax will fall into two categories:

| Concept       | Category    | Usage  |
|:--------------| :-----      | :----- |
| `fn`          | creation    |  `fn example_function<'a>()`  |
| `struct`      | creation    |  `struct Example<'a>`   |
| `enum`        | creation    |  `enum Test<'a>`   |
| `impl`        | creation    |  `impl<'a> Example<'a>`       |
| `struct`      | reference   |  `some_field: Example<'a>`   |
| `enum`        | reference   |  `some_field: Test<'a>`   |
| `&`           | reference   |  `next_field: &'a i32`     |
| `&mut`        | reference   |  `next_field: &'a mut i32`     |
| `Box`         | reference   |  `last_field: Box<i32 + 'a>`   |


# What does 'Category' mean?

When I say _'creation'_ I mean this is where the lifetime is first defined and named.

When I say _'reference'_ I mean this is where we are being explicit about the lifetime of some reference type, using a lifetime that already exists.

This is an important distinction that took me a while to get.

# Weird things

1. Yes, we see you `Box`, we're ignoring you.

2. Notice that 'struct' and 'enum' are in both categories. That's because they use pretty much the same syntax for creation as they do for reference; it's helpful to acknowledge that.

# More

I go into more detail about lifetimes [here]({% post_url 2015-10-29-rust-lifetimes %}).
