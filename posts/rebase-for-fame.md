---
layout: post
title: "git rebase for fame and power"
date: "2016-07-30 12:14:30 -0700"
categories: git
---

While learning git, people kept telling me "Don't re-base - you'll never need to re-base and it can screw things up".

This is terrible advice!

Re-basing is a great tool!

When you hear "Don't do <INSERT TOTALLY COOL THING>, you will break things" __*do that thing now!*__

**and** break things!

Re-basing by itself is not dangerous.

As long as you avoid `git push origin master --force` and only run `rm -rf .git`
every once in a while, you'll be totally fine.

# `git rebase`

When you type `git rebase master`, you say:

"I want to re-base my current branch."

"Even though I started on `20404df`,
make this branch off of the tip of master instead"

This works for any git object: commits, tags, branches.

# Why would I need to use this?

```bash
$ git checkout master && git log --pretty="%h -- %s"
ccccccc -- third commit
bbbbbbb -- second commit
aaaaaaa -- first commit

$ git checkout bbbbbbb
# make a new branch, based off of "second commit"
$ git checkout -b my_new_branch
$ touch a_file
$ git add a_file
$ git commit -m 'I just committed a file!'
$ git log --pretty="%h -- %s"
ddddddd -- I just committed a file!
bbbbbbb -- second commit
aaaaaaa -- first commit

# But I meant to make this commit on "third commit", not "second commit"!!!
# OH NOOOOO
# wait, I can re-base?
$ git rebase ccccccc
First, rewinding head to replay your work on top of it...
Applying: I just committed a file!

$ git log --pretty="%h -- %s"
ddddddd -- I just committed a file!
ccccccc -- third commit
bbbbbbb -- second commit
aaaaaaa -- first commit

# We just changed where the branch was based!
```

# If things go wrong...

This is a chance you screw everything up. Luckily, there are very few things
beyond repair in git.

If you do `git reflog`, you will see something like:

```bash
234320a HEAD@{0}: rebase finished: returning to refs/heads/my-new-branch
234320a HEAD@{1}: rebase: added a file
49211d7 HEAD@{2}: rebase: checkout 49211d7
8c90682 HEAD@{3}: checkout: moving from master to my-new-branch
```

You can then checkout `HEAD@{3}` to return to a safe state,
and then `git checkout -b saved-branch` to start committing.

As long as you don't `rm -rf .git`, you should be able to dig
yourself out of any holes `:)`
