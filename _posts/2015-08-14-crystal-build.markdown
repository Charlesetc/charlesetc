---
layout: post
title: "Crystal Build"
date: "2015-08-14 18:56:56 -0400"
---

Crystal is a relatively new, statically-typed language that very closely resembles ruby. While I'm very excited about it in general, that's not what this specific post is about: I'd like to document the process behind building it from source on Ubuntu.

# Install Crystal 

Since crystal is self-hosted, we can't compile it from source without first having a compiler for it. Getting a compiler is actually quite simple on Ubuntu:

```bash
sudo apt-get install crystal
```

# Errors

When trying to compile at this stage, I got a lot of library-missing errors. Here's roughly what they look like:

```bash
usr/bin/ld: cannot find -ledit
error: ld returned 1 exit status
```

Your mileage might vary depending on your system, so keep an eye out for this type of error: `-ledit` means that you're missing a library called LibEdit. ('l' stands for "lib"). Chances are this means you need to install the development version of this library, by running the following command:

```bash
sudo apt-get install libedit-dev
```

In general, `cannot find -llibrary` translates to running the command `sudo apt-get install liblibrary-dev`. Note that this may or may not include a number such as `liblibrary3-dev`. If the plain install doesn't work, googling should resolve the issue.

# Install Dependencies

Next is llvm:

```bash
sudo apt-get install llvm-3.5
```


