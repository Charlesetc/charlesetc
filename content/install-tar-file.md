---
title: "Install a tar file"
date: 2018-10-05T22:42:15-05:00
---

There have been a few times when I've been hoping to install some software, but it's distributed as a tar file of a directory structure.

The files are organized by where they should be installed, like so (shortened for clarity):

```
$ tree -L 3 swift-release-4.2
swift-release-4.2
└── usr
    ├── bin
    │   ├── lldb
    │   ├── repl_swift
    │   ├── swift
    ├── include
    │   └── lldb
    ├── lib
    │   ├── lldb
    │   ├── python2.7
    │   ├── swift
    ├── libexec
    │   └── swift
    ├── local
    │   └── include
    └── share
        ├── man
        └── swift

16 directories, 24 files
```

Now the task of actually putting these files under the root filesystem (`/`) instead of this `swift-release-4.2` directory is left up to the user.

This was something I struggled with the first couple times! I think I finally found a clean solution so I thought I'd share it.

```bash
for line in $(find * -type d); do
  sudo mkdir -p /$line
done

for line in $(find * -type f); do
  sudo cp $line /$line
done
```

It seems like there might be a canonical or easy way to do this. If so, let me know!
