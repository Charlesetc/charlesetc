---
layout: post
title:  "Dynamic Types: Races"
date:   2015-10-23 12:31:33
categories: types
---

We all agree dynamic types are Great, right?

Let the race begin.

# The Start

You start typing -- using alphabetic keys alone; the only symbols you need are "+", "-", and ".". You've already written 50 lines! That old guy sitting next to you starts up ghci, gets eclipse going, and has begun installing the latest gcc. You're halfway through the core logic and he's still writing types down on paper.

# Lap One

Two hours later, you look up from Pycharm and bask in the glory. You've got a 5,000 line codebase up and running! Sure, you might have chipped a few nails in the scurry but damn did you ace that. The guy next to you is sitting with a pen, scratching out something about higher order functions while waiting for his code to compile. What? Too easy. 

# Lap Two

Okay, well you're not quite done. You've still got to write tests, and every time you call `set_date` on the model it errors with `memory too damn full`, but oh well. You did great **for a two hour project**. And hey, that old guy only just started typing.

Here's the problem: You're friend Kelsi just stopped by and you're already having 3 requests a second. Not to mention that internal server error every other minute.

# Catching your breath

At this point, if you're a good programmer, you start writing some tests. Maybe you've already written a few, but can you really call `assert(user != null)` a test suite?

So for the next few days you labor on fixing all those small errors that you just didn't think about. That one place where a function call was missing the parentheses; another where you just didn't finish spelling `users`. And you find all of these mistakes with the help of tests! Hurray for tests!

Every time you fix something you make sure to add another one &mdash; especially to check that it's a plural `users`, not just one. [Yes, I have done this before]

And if you've done a good job you reach full coverage with every single variable being thoroughly tested.

# The Finish Line

Meanwhile, your friends have gotten tired of the sever errors and timeouts and have tried out the old man's service, which has been up and running steadily for a few days. 

# The End

Obviously it doesn't always go like this. And maybe a crazy good django developer really can program without mistakes. But *Oh My God* is debugging a waste of time. And statically typed languages ensure the only bugs you deal with are actual mistakes, not typos. 

I'd argue this saves vast amounts of time and sanity in the long run.
