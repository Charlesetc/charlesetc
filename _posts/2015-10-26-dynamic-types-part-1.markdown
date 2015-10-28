---
layout: post
title:  "Dynamic Types: Tests"
date:   2015-10-26 12:31:33
categories: jekyll update
---

It's pretty much agreed upon that an extensive test suite is the only way to write complicated and changing code.

Now let me be clear: Full test coverage is imperative. [Tests are my favorite construct in CS other than functions]

That said: __Most test suites in dynamic languages are dumb__

The tests that you get in a dynamic codebase tend to be asking the question "Is this exactly what I thought it was?"

The fact of the matter is, a codebase in a dynamic language is only well-written if it tests the internals and externals of every single variable, just to make sure it's behaving the way the programmer thought. Now let me ask you, which is more concise:

{% highlight ruby %}
before :each  {
  stateful_object = function_with_return_value
}

test {
  assert {
    stateful_object is not_null
  }

  assert {
    stateful_object.responds_to? :certain_method    # look familiar?
  }
}
{% endhighlight %}

{% highlight ruby %}
define function_with_return_value -> StatefulObjectClass {
  return StatefulObjectClass.new()
}
{% endhighlight %}

Each provides the same level of safety assurance. But the former is strictly worse:

1. It allows some things to remain unverified.
2. Leaving the task of verifying types up to humans is going to result in mistakes.
3. And no one wants to write such verbose assertions!


**_I am not advocating against test-driven development._**

I just want tests to verify logic, not spelling.
