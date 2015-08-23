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

Now here are the dependencies I had to install:

```bash
sudo apt-get install -y libg3-dev zlib1g-dev libxml2-dev libssl-dev libyaml-dev libreadline-dev # What the documentation gives you
sudo apt-get install llvm-3.5
sudo apt-get install libedit-dev
sudo apt-get install libpcre3-dev
sudo apt-get install libunwind-setjmp0-dev
sudo apt-get install libatomic-ops-dev
```

Now while this took a lot of guess and checking, those are all the packages available in the official Debian repositories.

#### Libgc 

However you're not quite done. First of all, you'll still need `libgc`. I had trouble with the version in the repositories but go ahead and try it:

```bash
sudo apt-get install libgc-dev
```

If you need to install from source, the process is:

```bash
wget https://launchpad.net/libgc/main/7.4.0/+download/gc-7.4.0.tar.gz
tar -xvf gc-7.4.0.tar.gz
cd gc-7.4.0
./configure
sudo make install
```

#### Libpcl

LibPCL seems to be a C library made, or at least hosted, by crystal-lang themselves. To install:

```bash
curl http://crystal-lang.s3.amazonaws.com/pcl/libpcl-1.12-1-linux-x86_64.tar.gz > libpcl.tar.gz
sudo mv libpcl.tar.gz /opt/crystal/
cd /opt/crystal
sudo tar -xvf libpcl.tar.gz -C ./embedded --strip-components=1
# Add the object file to the linking path:
sudo cp libpcl-1.12-1/lib/libpcl.so.1.0.11 /usr/lib
```

Finally, you need to add crystal to your path in your `.bashrc`: 
```bash
export LIBRARY_PATH=$LIBRARY_PATH:/opt/crystal/embedded/lib
```

## Compilation

Now you should be all set to bootstrap crystal!

```bash
git clone git@github.com:manastech/crystal.git
cd crystal
make
./bin/crystal samples/mandlebrot2.cr
```

You'll notice it takes a relatively short time to build. Hurray crystal!

## Notes:

If you have any questions or comments, please [e-mail me](mailto://cchamberlain@uchicago.edu).
