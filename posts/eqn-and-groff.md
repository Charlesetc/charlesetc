---
layout: post

title: "Eqn vs LaTeX"

date: "2017-01-17 12:14:30 -0700"

categories: unix eqn

---


Take the `LaTeX` code:

```latex
-1 \cdot \frac{1}{n}}\cup \{-1, \frac{1}{n}\}
```

Do you know what this means?

- difficult parse visually.
- uses lots of hard-to-type symbols.

Not only that, `TeX` by itself takes up 338.8 MB!

# Eqn

```ruby
-1 cdot 1 over n union left { -1 , 1 over n right } 
```

How's that for readability!

This is [eqn](http://www.zen89632.zen.co.uk/Groff/Eqn/eqnguide.pdf):
a math preprocessor on the layout engine
[groff](https://www.gnu.org/software/groff/). By the same metric, groff
takes up 8 MB.

And it works I promise!

![](/images/nonsense.png)

Even if the math is nonsensical, isn't it pretty!

# Links

You might already have groff/eqn on your machine! If not, take a look
[here](https://www.gnu.org/software/groff/).

[This repo](https://github.com/Charlesetc/eqn-template) is my template for
a simple eqn/groff project. [Here's](https://github.com/Charlesetc/eqn-template/blob/master/out.pdf)
what the pdf looks like.

Lastly, there is
[documentation](http://www.schaffter.ca/mom/momdoc/toc.html) for a groff
macro system, and [an in-depth
guide](http://www.zen89632.zen.co.uk/Groff/Eqn/eqnguide.pdf) for eqn!
